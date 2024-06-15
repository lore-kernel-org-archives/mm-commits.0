Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED11FBA
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718414081; cv=none; b=OBb9Q+cJTAUnTRMpnY/PZYcY1968wOhsq3ofiX0uzBicj72EQUa8f4cpu14vmr5nkjKh+JN2lc25zL/foBtWRVYgx0ImEWk2IwCAXhwMw6EvBwEj6jbQ7DwtZcboR4faW+kqLqHGlS+uRiEZW8rwlPrGDGNDkuBGxDXwdw46jLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718414081; c=relaxed/simple;
	bh=Ee7zZ69j3Gb0rIhVIUqqlX9/WSi5wUl+m+4SncViIok=;
	h=Date:To:From:Subject:Message-Id; b=sv7rp4TAPHJoM7jqaVLvXuoUYo33/Jnekkgahl39+mWs/rfvRudhhcNm7GQ5wH++Iw6Fl/k9+yy4mYgDgdtnh7uyatAzCgBhrrDwPnT+ONx5ptj1IPC8HPcblWC8nM/nc1ADSlDcvTkClE1XnqSSilRUADMuLHRrwpSojcL2FXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/v7FmqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/v7FmqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A37C2BD10;
	Sat, 15 Jun 2024 01:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718414081;
	bh=Ee7zZ69j3Gb0rIhVIUqqlX9/WSi5wUl+m+4SncViIok=;
	h=Date:To:From:Subject:From;
	b=D/v7FmqMDWPmJoVQyDvlt3s/BWpUReOzYWdhxoxV6NbiXvxw2XeEki/lOKlYrcdFB
	 mgROfi3K4FB1vqMojcpUxZ7wtpboThJv3vCue77GlsAeqOJ3PWuxwJWjhw0beasYu9
	 WRHgadiTlq+3juhRsI7p3rkWXqwnqe4Se7LpcOSo=
Date: Fri, 14 Jun 2024 18:14:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240615011441.23A37C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/slab: fix 'variable obj_exts set but not used' warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/slab: fix 'variable obj_exts set but not used' warning
Date: Fri, 14 Jun 2024 15:59:51 -0700

slab_post_alloc_hook() uses prepare_slab_obj_exts_hook() to obtain
slabobj_ext object.  Currently the only user of slabobj_ext object in this
path is memory allocation profiling, therefore when it's not enabled this
object is not needed.  This also generates a warning when compiling with
CONFIG_MEM_ALLOC_PROFILING=n.  Move the code under this configuration to
fix the warning.  If more slabobj_ext users appear in the future, the code
will have to be changed back to call prepare_slab_obj_exts_hook().

Link: https://lkml.kernel.org/r/20240614225951.3845577-1-surenb@google.com
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406150444.F6neSaiy-lkp@intel.com/
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slab-fix-variable-obj_exts-set-but-not-used-warning
+++ a/mm/slub.c
@@ -3902,7 +3902,6 @@ bool slab_post_alloc_hook(struct kmem_ca
 			  unsigned int orig_size)
 {
 	unsigned int zero_size = s->object_size;
-	struct slabobj_ext *obj_exts;
 	bool kasan_init = init;
 	size_t i;
 	gfp_t init_flags = flags & gfp_allowed_mask;
@@ -3945,9 +3944,11 @@ bool slab_post_alloc_hook(struct kmem_ca
 		kmemleak_alloc_recursive(p[i], s->object_size, 1,
 					 s->flags, init_flags);
 		kmsan_slab_alloc(s, p[i], init_flags);
+#ifdef CONFIG_MEM_ALLOC_PROFILING
 		if (need_slab_obj_ext()) {
+			struct slabobj_ext *obj_exts;
+
 			obj_exts = prepare_slab_obj_exts_hook(s, flags, p[i]);
-#ifdef CONFIG_MEM_ALLOC_PROFILING
 			/*
 			 * Currently obj_exts is used only for allocation profiling.
 			 * If other users appear then mem_alloc_profiling_enabled()
@@ -3955,8 +3956,8 @@ bool slab_post_alloc_hook(struct kmem_ca
 			 */
 			if (likely(obj_exts))
 				alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
-#endif
 		}
+#endif
 	}
 
 	return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
_

Patches currently in -mm which might be from surenb@google.com are

lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch
lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch
mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch

