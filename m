Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026222A7FE
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 04:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744777561; cv=none; b=G/B+71AKeYGYlEwKwFTbrPb6q9Xx7Ox5G386P/HpaX8Xd3tb671Lm7YlO64sf4uTr9CA6dX7TZXADdiGxNjGpdHTfnxAdqalmlf3F7RCOZ+KpnbxHD2LqbAl3jsMLrToqbJg9NTLV5oooOilSNDoYzZQRZkpsG0VRp8imNjLFPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744777561; c=relaxed/simple;
	bh=ow37d+6MFzdfklL5utkQghEtK1npK+B+uyzvE6+lWaA=;
	h=Date:To:From:Subject:Message-Id; b=UDgM0822BZsZ67FFzkXkRtKAN3xm/UDRrJl+YFKlCk3Il2ZqkQzXAUl7w/7QK+quBOtZkuzBHpJkmw8VjqZLaNrPeHdD4NGD7cSgY6Csl5lvcjVOmebkGgi/dftT9wCwVavIFsKuCs+XiaVS6YNEuMgjbJUUxFKk76nH89BnRrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sx9D+rQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sx9D+rQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE54C4CEEA;
	Wed, 16 Apr 2025 04:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744777561;
	bh=ow37d+6MFzdfklL5utkQghEtK1npK+B+uyzvE6+lWaA=;
	h=Date:To:From:Subject:From;
	b=sx9D+rQ4YEXmlnVuXBc2d7WxQa41wFdtToOmSfjTr94fdAgNHkFAaqRbKuanZGuqx
	 az7ErU5MfRvEdn26bTrT+BJhgpPWhVxcURyYlepQbheQ0N8ZPq8Dva0LFDBKEeQShQ
	 BDLBTo08CEO7khv6hAl/KDMzIqS4VF50sXRrAqDo=
Date: Tue, 15 Apr 2025 21:26:00 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zblock-allocator-fix.patch added to mm-new branch
Message-Id: <20250416042601.3EE54C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-zblock-allocator-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-zblock-allocator-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-zblock-allocator-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix
Date: Tue Apr 15 09:02:06 PM PDT 2025

fix build

Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zblock.c~mm-add-zblock-allocator-fix
+++ a/mm/zblock.c
@@ -328,7 +328,7 @@ static void zblock_zpool_destroy(void *p
 }
 
 static int zblock_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			unsigned long *handle)
+			unsigned long *handle, const int nid)
 {
 	return zblock_alloc(pool, size, gfp, handle);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch

