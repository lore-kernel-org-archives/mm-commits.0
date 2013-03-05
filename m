From: akpm@linux-foundation.org
Subject: + tidspbridge-convert-to-idr_alloc.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:18 -0800
Message-ID: <20130305220818.D96C531C1C6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:47360 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:20 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so792428ves.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, gregkh@linuxfoundation.org, omar.ramirez@ti.com, rene.sapiens@ti.com, vjaquez@igalia.com, x0095078@ti.com


The patch titled
     Subject: tidspbridge: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     tidspbridge-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Tejun Heo <tj@kernel.org>
Subject: tidspbridge: convert to idr_alloc()

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

There are some peculiarities and possible bugs in the converted
functions.  This patch preserves those.

* drv_insert_node_res_element() returns -ENOMEM on alloc failure,
  -EFAULT if id space is exhausted.  -EFAULT is at best misleading.

* drv_proc_insert_strm_res_element() is even weirder.  It returns
  -EFAULT if kzalloc() fails, -ENOMEM if idr preloading fails and
  -EPERM if id space is exhausted.  What's going on here?

* drv_proc_insert_strm_res_element() doesn't free *pstrm_res after
  failure.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: V=EDctor Manuel J=E1quez Leal <vjaquez@igalia.com>
Cc: Rene Sapiens <rene.sapiens@ti.com>
Cc: Armando Uribe <x0095078@ti.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/tidspbridge/rmgr/drv.c |   70 ++++++++---------------
 1 file changed, 26 insertions(+), 44 deletions(-)

diff -puN drivers/staging/tidspbridge/rmgr/drv.c~tidspbridge-convert-to=
-idr_alloc drivers/staging/tidspbridge/rmgr/drv.c
--- a/drivers/staging/tidspbridge/rmgr/drv.c~tidspbridge-convert-to-idr=
_alloc
+++ a/drivers/staging/tidspbridge/rmgr/drv.c
@@ -76,37 +76,28 @@ int drv_insert_node_res_element(void *hn
 	struct node_res_object **node_res_obj =3D
 	    (struct node_res_object **)node_resource;
 	struct process_context *ctxt =3D (struct process_context *)process_ct=
xt;
-	int status =3D 0;
 	int retval;
=20
 	*node_res_obj =3D kzalloc(sizeof(struct node_res_object), GFP_KERNEL)=
;
-	if (!*node_res_obj) {
-		status =3D -ENOMEM;
-		goto func_end;
-	}
+	if (!*node_res_obj)
+		return -ENOMEM;
=20
 	(*node_res_obj)->node =3D hnode;
-	retval =3D idr_get_new(ctxt->node_id, *node_res_obj,
-						&(*node_res_obj)->id);
-	if (retval =3D=3D -EAGAIN) {
-		if (!idr_pre_get(ctxt->node_id, GFP_KERNEL)) {
-			pr_err("%s: OUT OF MEMORY\n", __func__);
-			status =3D -ENOMEM;
-			goto func_end;
-		}
-
-		retval =3D idr_get_new(ctxt->node_id, *node_res_obj,
-						&(*node_res_obj)->id);
+	retval =3D idr_alloc(ctxt->node_id, *node_res_obj, 0, 0, GFP_KERNEL);
+	if (retval >=3D 0) {
+		(*node_res_obj)->id =3D retval;
+		return 0;
 	}
-	if (retval) {
+
+	kfree(*node_res_obj);
+
+	if (retval =3D=3D -ENOSPC) {
 		pr_err("%s: FAILED, IDR is FULL\n", __func__);
-		status =3D -EFAULT;
+		return -EFAULT;
+	} else {
+		pr_err("%s: OUT OF MEMORY\n", __func__);
+		return -ENOMEM;
 	}
-func_end:
-	if (status)
-		kfree(*node_res_obj);
-
-	return status;
 }
=20
 /* Release all Node resources and its context
@@ -201,35 +192,26 @@ int drv_proc_insert_strm_res_element(voi
 	struct strm_res_object **pstrm_res =3D
 	    (struct strm_res_object **)strm_res;
 	struct process_context *ctxt =3D (struct process_context *)process_ct=
xt;
-	int status =3D 0;
 	int retval;
=20
 	*pstrm_res =3D kzalloc(sizeof(struct strm_res_object), GFP_KERNEL);
-	if (*pstrm_res =3D=3D NULL) {
-		status =3D -EFAULT;
-		goto func_end;
-	}
+	if (*pstrm_res =3D=3D NULL)
+		return -EFAULT;
=20
 	(*pstrm_res)->stream =3D stream_obj;
-	retval =3D idr_get_new(ctxt->stream_id, *pstrm_res,
-						&(*pstrm_res)->id);
-	if (retval =3D=3D -EAGAIN) {
-		if (!idr_pre_get(ctxt->stream_id, GFP_KERNEL)) {
-			pr_err("%s: OUT OF MEMORY\n", __func__);
-			status =3D -ENOMEM;
-			goto func_end;
-		}
-
-		retval =3D idr_get_new(ctxt->stream_id, *pstrm_res,
-						&(*pstrm_res)->id);
+	retval =3D idr_alloc(ctxt->stream_id, *pstrm_res, 0, 0, GFP_KERNEL);
+	if (retval >=3D 0) {
+		(*pstrm_res)->id =3D retval;
+		return 0;
 	}
-	if (retval) {
+
+	if (retval =3D=3D -ENOSPC) {
 		pr_err("%s: FAILED, IDR is FULL\n", __func__);
-		status =3D -EPERM;
+		return -EPERM;
+	} else {
+		pr_err("%s: OUT OF MEMORY\n", __func__);
+		return -ENOMEM;
 	}
-
-func_end:
-	return status;
 }
=20
 static int drv_proc_free_strm_res(int id, void *p, void *process_ctxt)
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
idr-remove-warn_on_once-on-negative-ids.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removabl=
e-devices.patch
rtc-add-devm_rtc_device_registerunregister.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-remove-unused-get_new_stid.patch
nfsd-convert-to-idr_alloc.patch
workqueue-convert-to-idr_alloc.patch
mlx4-remove-leftover-idr_pre_get-call.patch
zcache-convert-to-idr_alloc.patch
tidspbridge-convert-to-idr_alloc.patch
idr-deprecate-idr_pre_get-and-idr_get_new.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
