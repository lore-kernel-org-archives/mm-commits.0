Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F858C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E434C65177
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhCHXI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhCHXIZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE04652A4;
        Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244905;
        bh=allnM2ZFfLvknVC8P/vmDk2axdKCnO1ltipMFF9AGbs=;
        h=Date:From:To:Subject:From;
        b=0tr/p8/6IQ6Yr57+L76gDj7+vF3T/VhSKRT5sVy+zDtDxTdabv/nk0gSltFiJP66b
         QFdKy6vjhqvGMakVXU2dyGheKJHGfMKinVZ6abxpMZAw3wMEySqz6ApsdNvMb4WjHC
         W4Ag79Bn0H5Qv5KYZKmiH6kNOl9zhEa6VEUHffds=
Date:   Mon, 08 Mar 2021 15:08:24 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  + cgroup-rstat-support-cgroup1.patch added to -mm tree
Message-ID: <20210308230824.JIClPHwHU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: rstat: support cgroup1
has been added to the -mm tree.  Its filename is
     cgroup-rstat-support-cgroup1.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cgroup-rstat-support-cgroup1.=
patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cgroup-rstat-support-cgroup1.=
patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: cgroup: rstat: support cgroup1

Rstat currently only supports the default hierarchy in cgroup2.  In order
to replace memcg's private stats infrastructure - used in both cgroup1 and
cgroup2 - with rstat, the latter needs to support cgroup1.

The initialization and destruction callbacks for regular cgroups are
already in place.  Remove the cgroup_on_dfl() guards to handle cgroup1.

The initialization of the root cgroup is currently hardcoded to only
handle cgrp_dfl_root.cgrp.  Move those callbacks to cgroup_setup_root()
and cgroup_destroy_root() to handle the default root as well as the
various cgroup1 roots we may set up during mounting.

The linking of css to cgroups happens in code shared between cgroup1 and
cgroup2 as well.  Simply remove the cgroup_on_dfl() guard.

Linkage of the root css to the root cgroup is a bit trickier: per default,
the root css of a subsystem controller belongs to the default hierarchy
(i.e.  the cgroup2 root).  When a controller is mounted in its cgroup1
version, the root css is stolen and moved to the cgroup1 root; on unmount,
the css moves back to the default hierarchy.  Annotate rebind_subsystems()
to move the root css linkage along between roots.

Link: https://lkml.kernel.org/r/20210209163304.77088-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |   34 +++++++++++++++++++++-------------
 kernel/cgroup/rstat.c  |    2 --
 2 files changed, 21 insertions(+), 15 deletions(-)

--- a/kernel/cgroup/cgroup.c~cgroup-rstat-support-cgroup1
+++ a/kernel/cgroup/cgroup.c
@@ -1339,6 +1339,7 @@ static void cgroup_destroy_root(struct c
=20
 	mutex_unlock(&cgroup_mutex);
=20
+	cgroup_rstat_exit(cgrp);
 	kernfs_destroy_root(root->kf_root);
 	cgroup_free_root(root);
 }
@@ -1751,6 +1752,12 @@ int rebind_subsystems(struct cgroup_root
 				       &dcgrp->e_csets[ss->id]);
 		spin_unlock_irq(&css_set_lock);
=20
+		if (ss->css_rstat_flush) {
+			list_del_rcu(&css->rstat_css_node);
+			list_add_rcu(&css->rstat_css_node,
+				     &dcgrp->rstat_css_list);
+		}
+
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |=3D 1 << ssid;
 		if (dst_root =3D=3D &cgrp_dfl_root) {
@@ -1971,10 +1978,14 @@ int cgroup_setup_root(struct cgroup_root
 	if (ret)
 		goto destroy_root;
=20
-	ret =3D rebind_subsystems(root, ss_mask);
+	ret =3D cgroup_rstat_init(root_cgrp);
 	if (ret)
 		goto destroy_root;
=20
+	ret =3D rebind_subsystems(root, ss_mask);
+	if (ret)
+		goto exit_stats;
+
 	ret =3D cgroup_bpf_inherit(root_cgrp);
 	WARN_ON_ONCE(ret);
=20
@@ -2006,6 +2017,8 @@ int cgroup_setup_root(struct cgroup_root
 	ret =3D 0;
 	goto out;
=20
+exit_stats:
+	cgroup_rstat_exit(root_cgrp);
 destroy_root:
 	kernfs_destroy_root(root->kf_root);
 	root->kf_root =3D NULL;
@@ -4934,8 +4947,7 @@ static void css_free_rwork_fn(struct wor
 			cgroup_put(cgroup_parent(cgrp));
 			kernfs_put(cgrp->kn);
 			psi_cgroup_free(cgrp);
-			if (cgroup_on_dfl(cgrp))
-				cgroup_rstat_exit(cgrp);
+			cgroup_rstat_exit(cgrp);
 			kfree(cgrp);
 		} else {
 			/*
@@ -4976,8 +4988,7 @@ static void css_release_work_fn(struct w
 		/* cgroup release path */
 		TRACE_CGROUP_PATH(release, cgrp);
=20
-		if (cgroup_on_dfl(cgrp))
-			cgroup_rstat_flush(cgrp);
+		cgroup_rstat_flush(cgrp);
=20
 		spin_lock_irq(&css_set_lock);
 		for (tcgrp =3D cgroup_parent(cgrp); tcgrp;
@@ -5034,7 +5045,7 @@ static void init_and_link_css(struct cgr
 		css_get(css->parent);
 	}
=20
-	if (cgroup_on_dfl(cgrp) && ss->css_rstat_flush)
+	if (ss->css_rstat_flush)
 		list_add_rcu(&css->rstat_css_node, &cgrp->rstat_css_list);
=20
 	BUG_ON(cgroup_css(cgrp, ss));
@@ -5159,11 +5170,9 @@ static struct cgroup *cgroup_create(stru
 	if (ret)
 		goto out_free_cgrp;
=20
-	if (cgroup_on_dfl(parent)) {
-		ret =3D cgroup_rstat_init(cgrp);
-		if (ret)
-			goto out_cancel_ref;
-	}
+	ret =3D cgroup_rstat_init(cgrp);
+	if (ret)
+		goto out_cancel_ref;
=20
 	/* create the directory */
 	kn =3D kernfs_create_dir(parent->kn, name, mode, cgrp);
@@ -5250,8 +5259,7 @@ out_psi_free:
 out_kernfs_remove:
 	kernfs_remove(cgrp->kn);
 out_stat_exit:
-	if (cgroup_on_dfl(parent))
-		cgroup_rstat_exit(cgrp);
+	cgroup_rstat_exit(cgrp);
 out_cancel_ref:
 	percpu_ref_exit(&cgrp->self.refcnt);
 out_free_cgrp:
--- a/kernel/cgroup/rstat.c~cgroup-rstat-support-cgroup1
+++ a/kernel/cgroup/rstat.c
@@ -285,8 +285,6 @@ void __init cgroup_rstat_boot(void)
=20
 	for_each_possible_cpu(cpu)
 		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
-
-	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
 }
=20
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

