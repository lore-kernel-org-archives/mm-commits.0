Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC05738E126
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298401; cv=none; b=gFK1san4OZVOHBJm6jQChmoIZ+9VQ7U1SvdvC/0pX97OQChglkMNH/lP3+NmP2UUvp0lFDQpKBVHY7X3uu6g/HJIK310GsynR1/kJg6qciug1w2XHp3rPNG6q1Ru6i3kkB4YG8bzE7g2HwJmEvleMYHSPBbLSEeYAg1Va+g9V/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298401; c=relaxed/simple;
	bh=ef6BFdjzrEGXyI0blF4vnj9NEwKk4/f3IM7XJWItcUQ=;
	h=Date:To:From:Subject:Message-Id; b=G1rGGw57YuRbHUhsi5rAnxC6NAqOXnovwv/0bJnIJgv0BfZAEvnT173xvhISN9kVV6NStv83p8HNU3yCzh12Laj8RvqSYclHcmUCC1TEUNJ7aTl1sqTUJUkVQr/mJzmjCZXPCiV1rDSnNXrS3xRvK+X54N8pNyYMvsauIZpcwtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S9tWsoJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9tWsoJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AEF1F00A3A;
	Wed, 29 Jul 2026 04:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298400;
	bh=i669ivhTPRnlNjEimxNsEwmzVu4nDBZSyaWmWTHKXXo=;
	h=Date:To:From:Subject;
	b=S9tWsoJw6ciBLv0PCsyndlYidB68h8WHQIebYTdwenMn01kLxwzWNQaNFqS43v1gf
	 8oWdxEsSi551oi3N1IY3HYzl4OuSsoueacwQgpuSrLxGRAYDKK6yWJsrVauoyiCP7l
	 3D6tT3uaM6Sj4+o2/DmaSF0P+pzRoT4l2NkOP/58=
Date: Tue, 28 Jul 2026 21:13:20 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,glider@google.com,dvyukov@google.com,dja@axtens.net,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch removed from -mm tree
Message-Id: <20260729041320.91AEF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use more common error handling code in pcpu_get_vm_areas()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/vmalloc: use more common error handling code in pcpu_get_vm_areas()
Date: Tue, 16 Jun 2026 18:14:52 +0200

Use an existing label once more so that a bit of exception handling can be
better reused at the end of this function implementation.

This issue was detected by using the Coccinelle software.

Link: https://lore.kernel.org/453375c4-c3ca-4e6f-8880-0e6ff3c74ee3@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -5199,9 +5199,7 @@ err_free_shadow:
 		kfree(vms[area]);
 	}
 	spin_unlock(&free_vmap_area_lock);
-	kfree(vas);
-	kfree(vms);
-	return NULL;
+	goto err_free2;
 }
 
 /**
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


