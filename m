Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B793114830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011009; cv=none; b=QzYTiF21WrByUbmXxdQp4WfxG2pPcaIEBSkBXdaNR+B7dT/2bzICCvaVEGM2T5oY52EVibjzRxCAAIPHyCgR1Wa8oOhuZE/8oPtEz/PcKAJTRahKvNjMitQDRuVillKWmEKpGiehIBP1DmueXGF8RGIF6MUmvpk3XdpV62zfUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011009; c=relaxed/simple;
	bh=hyUmbuv+yn44Slj+2Ku9qMpilDSR2bX4VzWiiZGdvP8=;
	h=Date:To:From:Subject:Message-Id; b=nGJGp5xLV9Al30sUQC+nOkork66pJezSCkY3e5448dmW/DMoP4PCrwhe7IlLnagec7ztQfnNznc4OhRpjZ+oTFZgPdY1GltxUmKKSJ0PbtpTU4isOshn2+irbdfz0j2nF2YDlgralCbChM0vLp5jS6GqSyAitjDfP7jqpo882SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClnUrVVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClnUrVVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AB0C4CEE4;
	Mon, 12 May 2025 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011009;
	bh=hyUmbuv+yn44Slj+2Ku9qMpilDSR2bX4VzWiiZGdvP8=;
	h=Date:To:From:Subject:From;
	b=ClnUrVVSAe1X3GAwaMMNef2v5c/B9r3gxCnz+/uZkKsZkkzMqdvJtshcB9WiTsufu
	 8Kc4z4nvVUH+h3u8us7FsM2JqsQD8ve0y1C355X+oF0GdRgTeM25dOuWJWzKnQCsB5
	 uhQFBRqLBeA1XPDgjzZLS+u4fXVrwAOxGCeIPIus=
Date: Sun, 11 May 2025 17:50:08 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ignacio@iencinas.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-annotate-data-race-in-update_hiwater_rss.patch removed from -mm tree
Message-Id: <20250512005009.28AB0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: annotate data race in update_hiwater_rss
has been removed from the -mm tree.  Its filename was
     mm-annotate-data-race-in-update_hiwater_rss.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ignacio Encinas <ignacio@iencinas.com>
Subject: mm: annotate data race in update_hiwater_rss
Date: Mon, 31 Mar 2025 21:57:05 +0200

mm_struct.hiwater_rss can be accessed concurrently without proper
synchronization as reported by KCSAN.

This data race is benign as it only affects accounting information.
Annotate it with data_race() to make KCSAN happy.

Link: https://lkml.kernel.org/r/20250331-mm-maxrss-data-race-v2-1-cf958e6205bf@iencinas.com
Signed-off-by: Ignacio Encinas <ignacio@iencinas.com>
Reported-by: syzbot+419c4b42acc36c420ad3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67e3390c.050a0220.1ec46.0001.GAE@google.com/
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-annotate-data-race-in-update_hiwater_rss
+++ a/include/linux/mm.h
@@ -12,6 +12,7 @@
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
 #include <linux/debug_locks.h>
+#include <linux/compiler.h>
 #include <linux/mm_types.h>
 #include <linux/mmap_lock.h>
 #include <linux/range.h>
@@ -2796,7 +2797,7 @@ static inline void update_hiwater_rss(st
 {
 	unsigned long _rss = get_mm_rss(mm);
 
-	if ((mm)->hiwater_rss < _rss)
+	if (data_race(mm->hiwater_rss) < _rss)
 		(mm)->hiwater_rss = _rss;
 }
 
_

Patches currently in -mm which might be from ignacio@iencinas.com are


