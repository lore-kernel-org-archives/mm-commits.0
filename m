From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 009/128] slub: Remove userspace notifier for cache
 add/remove
Date: Mon, 01 Jun 2020 21:45:50 -0700
Message-ID: <20200602044550.5r93m7jjY%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:45:51 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mkoutny@suse.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
@@ -5715,19 +5715,6 @@ static struct kobj_type slab_ktype =3D {
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
@@ -5795,7 +5782,6 @@ static void sysfs_slab_remove_workfn(str
 #ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
-	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 out:
 	kobject_put(&s->kobj);
 }
@@ -5853,7 +5839,6 @@ static int sysfs_slab_add(struct kmem_ca
 	}
 #endif
=20
-	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
@@ -5934,7 +5919,7 @@ static int __init slab_sysfs_init(void)
=20
 	mutex_lock(&slab_mutex);
=20
-	slab_kset =3D kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
+	slab_kset =3D kset_create_and_add("slab", NULL, kernel_kobj);
 	if (!slab_kset) {
 		mutex_unlock(&slab_mutex);
 		pr_err("Cannot register slab subsystem.\n");
_
