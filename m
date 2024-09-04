Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521761E630A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477571; cv=none; b=kAaJCqK6EcNxxTxGN+xImzv/gxjjyJuoQU6s8WXOZbIKHN+3dzySUdoYsMTcY2B4wt1CezIq3BFu+GxAQkHb0XY2DqeEmfHPsvIQb4suPIp8oRmZuZa3hOF8paDq3f52LT9b4GEs08m/aKVZVSDzzUM90KKZt22xuk8rDkzVgU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477571; c=relaxed/simple;
	bh=hLi4kg3EPfYAYGfNni85g1cKw8Hhat2tgCMPK4JIQ1g=;
	h=Date:To:From:Subject:Message-Id; b=pAmX0KIwcf1pIuZYDGoKFnr7gR131KNXcQ16Dw+c7uErMid3FCv2FlF7p2lmK7FYYlejHY8cgg7j+ANgexHDrNc3U8Tvc3lGIlNG0xSYIKXtIpV3ordhfDX2na0kcOk496mlAxpP74uvYG3DhHjMKN+NF6KoS/2V64zS//Z4E/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FCMRSJMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FCMRSJMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BBEC4CEC9;
	Wed,  4 Sep 2024 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725477571;
	bh=hLi4kg3EPfYAYGfNni85g1cKw8Hhat2tgCMPK4JIQ1g=;
	h=Date:To:From:Subject:From;
	b=FCMRSJMuZ/T6hlI7nmeQihbQ+Pcag1kWiyB2V4j0O4XuBifq4qsEeVgGNxBMhHlIx
	 1Ua9acanfCDrcfBIIXyJiTeeCiQdnV75UZdVVd2Mzu5Tl6flHEvz5aS0QlxAEXcbjH
	 n+f4i/AiniWUHtdZ19VKAgcc8VbhB28dCO24JNg8=
Date: Wed, 04 Sep 2024 12:19:30 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-duplicate-unlikely-usage.patch added to mm-nonmm-unstable branch
Message-Id: <20240904191930.F3BBEC4CEC9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: remove duplicate 'unlikely()' usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-duplicate-unlikely-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-duplicate-unlikely-usage.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kunwu Chan <chentao@kylinos.cn>
Subject: nilfs2: remove duplicate 'unlikely()' usage
Date: Wed, 4 Sep 2024 19:16:03 +0900

Nested unlikely() calls, IS_ERR already uses unlikely() internally

Link: https://lkml.kernel.org/r/20240904101618.17716-1-konishi.ryusuke@gmail.com
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/page.c~nilfs2-remove-duplicate-unlikely-usage
+++ a/fs/nilfs2/page.c
@@ -262,7 +262,7 @@ repeat:
 			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
-		if (unlikely(IS_ERR(dfolio))) {
+		if (IS_ERR(dfolio)) {
 			/* No empty page is added to the page cache */
 			folio_unlock(folio);
 			err = PTR_ERR(dfolio);
_

Patches currently in -mm which might be from chentao@kylinos.cn are

nilfs2-remove-duplicate-unlikely-usage.patch

