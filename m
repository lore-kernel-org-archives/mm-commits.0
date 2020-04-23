From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 slub-remove-userspace-notifier-for-cache-add-remove.patch added to -mm tree
Date: Thu, 23 Apr 2020 16:32:31 -0700
Message-ID: <20200423233231.lApGtty1c%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgDWXcc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 19:32:32 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, mkoutny@suse.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: slub: Remove userspace notifier for cache add/remove
has been added to the -mm tree.  Its filename is
     slub-remove-userspace-notifier-for-cache-add-remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-remove-userspace-notifier=
-for-cache-add-remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-remove-userspace-notifier=
-for-cache-add-remove.patch

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
=46rom: Christoph Lameter <cl@linux.com>
Subject: slub: Remove userspace notifier for cache add/remove

I came across some unnecessary uevents once again which reminded me this.=
=20
The patch seems to be lost in the leaves of the original discussion [1],
so resending.

[1] https://lore.kernel.org/r/alpine.DEB.2.21.2001281813130.745@www.lameter=
.com

Kmem caches are internal kernel structures so it is strange that userspace
notifiers would be needed.  And I am not aware of any use of these
notifiers.  These notifiers may just exist because in the initial slub
release the sysfs code was copied from another subsystem.

Link: http://lkml.kernel.org/r/20200423115721.19821-1-mkoutny@suse.com
Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/mm/slub.c~slub-remove-userspace-notifier-for-cache-add-remove
+++ a/mm/slub.c
@@ -5700,19 +5700,6 @@ static struct kobj_type slab_ktype =3D {
 	.release =3D kmem_cache_release,
 };
=20
-static int uevent_filter(struct kset *kset, struct kobject *kobj)
-{
-	struct kobj_type *ktype =3D get_ktype(kobj);
-
-	if (ktype =3D=3D &slab_ktype)
-		return 1;
-	return 0;
-}
-
-static const struct kset_uevent_ops slab_uevent_ops =3D {
-	.filter =3D uevent_filter,
-};
-
 static struct kset *slab_kset;
=20
 static inline struct kset *cache_kset(struct kmem_cache *s)
@@ -5780,7 +5767,6 @@ static void sysfs_slab_remove_workfn(str
 #ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
-	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 out:
 	kobject_put(&s->kobj);
 }
@@ -5838,7 +5824,6 @@ static int sysfs_slab_add(struct kmem_ca
 	}
 #endif
=20
-	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
@@ -5919,7 +5904,7 @@ static int __init slab_sysfs_init(void)
=20
 	mutex_lock(&slab_mutex);
=20
-	slab_kset =3D kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
+	slab_kset =3D kset_create_and_add("slab", NULL, kernel_kobj);
 	if (!slab_kset) {
 		mutex_unlock(&slab_mutex);
 		pr_err("Cannot register slab subsystem.\n");
_

Patches currently in -mm which might be from cl@linux.com are

slub-remove-userspace-notifier-for-cache-add-remove.patch
