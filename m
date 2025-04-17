Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63621506E
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933967; cv=none; b=BIC4fbMajugeten2UKMQU9h/3ihJVZjNv7CvwPbozFc7Su3N58TflnY3l/OI4e9V/vey9jc4kQmU4pzaYiEN7qF9h67oO36abUHr90rDsy1vJ+8vegai5VFJ+QoIs18W7TJXVZYNoKgi12Np0RzXov+903jn1FAubYE0QrgKy8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933967; c=relaxed/simple;
	bh=5r38oupV3Wpa3Kr/fy26wFS/GX44TzfRqi15U2nmtVs=;
	h=Date:To:From:Subject:Message-Id; b=e/+4zGYKu5129/rnY5kdhMjwaLpC6StznB9Z23Z0rslJF2/0GQLOBRnwZZDy7vN22E18qFAM4iPGMvApSIwY1nMg3GtvRZj33piWnFK3VWVnp+RvbW5RulFyWrVx4zDZSVfQnGdJMkyKPd3kdM6CHN4gJCFiUMW4xZOvc8lv29Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUj4/aH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUj4/aH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2406C4CEE4;
	Thu, 17 Apr 2025 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744933966;
	bh=5r38oupV3Wpa3Kr/fy26wFS/GX44TzfRqi15U2nmtVs=;
	h=Date:To:From:Subject:From;
	b=vUj4/aH5VUuAh/DxrgZy9r6xbABVKOA4YhJRxs7pbjZ+og9wdjn4dXnphfgwxPC+Y
	 znb3+OKXgkv3FPE8XghKGjo616MVeOD/uOuphgn1GbnYgWblrOP705SbDYtJAc4hnM
	 +MSVmZ/zCWcURe8uhAyynLNUX0SKq/MqKKEEYru8=
Date: Thu, 17 Apr 2025 16:52:46 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-test_vmallocc-to-vmalloc-section.patch added to mm-new branch
Message-Id: <20250417235246.B2406C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add test_vmalloc.c to VMALLOC section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-test_vmallocc-to-vmalloc-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-test_vmallocc-to-vmalloc-section.patch

This patch will later appear in the mm-new branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: MAINTAINERS: add test_vmalloc.c to VMALLOC section
Date: Thu, 17 Apr 2025 18:12:15 +0200

A vmalloc subsystem includes "lib/test_vmalloc.c" test suite.  Add an "F:"
entry under VMALLOC section to track this file as part of the subsystem.

Link: https://lkml.kernel.org/r/20250417161216.88318-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-test_vmallocc-to-vmalloc-section
+++ a/MAINTAINERS
@@ -25823,6 +25823,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
 F:	mm/vmalloc.c
+F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

