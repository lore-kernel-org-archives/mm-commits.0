Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD086F068
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721855779; cv=none; b=iusJAPKWrA+FB0vv32FHvR0FQM5D4AjeqN6jYOx/GZ63pvGqM0qDkfjIwYKUyPXYzUjzpvuHkCRMEi0PLQJHhKfzhm2K/EiMrY35MMNcjvXsUga5y1pNBfmZCxFBQJQwowDLcjh7wnbsQ/I50UnGSNlvWVUFda47n8MHFfk92Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721855779; c=relaxed/simple;
	bh=CIgD8EGdYvzTrlFK6+/XvWD6MtYMT2+VeZNj6g9dqbM=;
	h=Date:To:From:Subject:Message-Id; b=PPg9Yn8RkGT5lZk4kJm3kx/j5OMLS/1QAAX4R+YRASaXvvk2EanvjSf9Px3SbI9tCiL0u56FYAVhZMWdMuLalF+NQafAl9r2ashe0hJGI/e1sTz61TUNXcrSyj9zidQXTwgeSjuGxKbUdwJkw5ef6YKpahOmxXjO1uq5Rx+no3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c2MSLzFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c2MSLzFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C5DC32781;
	Wed, 24 Jul 2024 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721855778;
	bh=CIgD8EGdYvzTrlFK6+/XvWD6MtYMT2+VeZNj6g9dqbM=;
	h=Date:To:From:Subject:From;
	b=c2MSLzFKI3kz+gHazzukUagHLUYZw787xux2ZfYNJe2mT5wp1I0Xz0DzMwCGaFROk
	 o+jYL70jD2CHOVu8GspuF56sff/JSac/8Eg6VXi7Yk5I3Ky8QrhkieH7J0OB6yJx5A
	 R3RdYw3q8dnAt1wTQYNkAwBfAotEG6itjI6VnsLI=
Date: Wed, 24 Jul 2024 14:16:13 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,jannh@google.com,iamjoonsoo.kim@lge.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,andreyknvl@gmail.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix.patch added to mm-unstable branch
Message-Id: <20240724211618.D4C5DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix
Date: Wed Jul 24 02:11:59 PM PDT 2024

fix CONFIG_KASAN=n build

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/kasan.h~kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix
+++ a/include/linux/kasan.h
@@ -381,6 +381,12 @@ static inline void *kasan_init_slab_obj(
 {
 	return (void *)object;
 }
+
+static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object)
+{
+	return false;
+}
+
 static inline bool kasan_slab_free(struct kmem_cache *s, void *object, bool init)
 {
 	return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-catch-invalid-free-before-slub-reinitializes-the-object-fix.patch

