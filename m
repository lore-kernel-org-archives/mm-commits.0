Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43990125DB
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255685; cv=none; b=rGz9N5g57hHIIAYQF12PjGdvXQQwLgOr7pAv0xoclGiIvfF/yPth4AAa7RYFK80NFAqe3AR++iisck2liVySI+02HZ4EtyT1uv1Go20uIXc6res4aB9E0SpMiApTDni0+cjvKY36/ha4hp50V4gkvnaWJWzPrvWGAnAHqeYZXB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255685; c=relaxed/simple;
	bh=wKOGlF0HK3OnXQ6BCaF7lnINnz0Id8s9up7XWDfhJEo=;
	h=Date:To:From:Subject:Message-Id; b=nYEG6wTx/PZV4U9m74vn4YyHy3qfupFufskuIfIBcA90ifSwbUw7Yaqt1pcycODoPnoZ7zbBIliZgUnRTmHpFMEJMpGHUzhFCgwjRz3/b4bZbLV/UUozNKdrKLmGO9iqkmejScdolPox+1NI4+yE/2qoNlIkH47EIwmeBVbyito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ili0yHSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ili0yHSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E96CC433F1;
	Fri, 26 Jan 2024 07:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255684;
	bh=wKOGlF0HK3OnXQ6BCaF7lnINnz0Id8s9up7XWDfhJEo=;
	h=Date:To:From:Subject:From;
	b=Ili0yHSJDHNLtq7CCoxBGNEtx6KjfyPuQasB1Ea78JwggyYfXsXBzfPfE+XUGb7KQ
	 orfh1DYETW6DoxYw4quq8dYHFlomxt2gi4bbQBSL/N0DBs2tS8GdhkcUUInGpBxdla
	 iVNotUWdks5N1wSs90O76GOlm/S+CulAJoon65Ts=
Date: Thu, 25 Jan 2024 23:54:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,guoxuenan@huawei.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] readahead-avoid-multiple-marked-readahead-pages-v2.patch removed from -mm tree
Message-Id: <20240126075444.3E96CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: Avoid multiple marked readahead pages
has been removed from the -mm tree.  Its filename was
     readahead-avoid-multiple-marked-readahead-pages-v2.patch

This patch was dropped because it was folded into readahead-avoid-multiple-marked-readahead-pages.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: Avoid multiple marked readahead pages
Date: Tue, 23 Jan 2024 16:32:54 +0100

fix one more place where mark rounding was done as well

Link: https://lkml.kernel.org/r/20240123153254.5206-1-jack@suse.cz
Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-avoid-multiple-marked-readahead-pages-v2
+++ a/mm/readahead.c
@@ -575,7 +575,7 @@ static void ondemand_readahead(struct re
 	 * It's the expected callback index, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	expected = round_up(ra->start + ra->size - ra->async_size,
+	expected = round_down(ra->start + ra->size - ra->async_size,
 			1UL << order);
 	if (index == expected || index == (ra->start + ra->size)) {
 		ra->start += ra->size;
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-avoid-multiple-marked-readahead-pages.patch

