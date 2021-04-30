Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5FFC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D12E661480
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhD3F5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhD3F5J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF45E61476;
        Fri, 30 Apr 2021 05:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762181;
        bh=QnuCeJ6yGDxxd0Rx0rkyI/CUVjbtRy0AqsoHQf1nIo8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eMhJa8IQrvbJsmzuUraX/WJM051FCw65m4LWLUu+r5+gIU1CaM4wDTJCWtlhVUJV+
         442TVinpfmwj+TIhntH+cqDMDvBQJXDF+PoUlc5ETrtcXiacqlfI3/K4FtyX4f46aa
         5z1x7Bq5pCCF5jRMjowOulverQJdGDflJYVqsazo=
Date:   Thu, 29 Apr 2021 22:56:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 062/178] cgroup: rstat: support cgroup1
Message-ID: <20210430055620.3DpR2owjy%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
