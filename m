Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191C114BF8D;
	Thu, 30 May 2024 19:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717097915; cv=none; b=gKpa43Drj/778k09499TgW3UV8RIDSLPFnm3wEz9qCpCoU9zuiRNF1ymlARbvi559qLXwJnaUN/kbObTkVty9W5ZP8kNY6HLUwLmdXArkrswWpa6cn5sveJebXQx66fY+kQm6xUtf6ehgPo6vJJGdM07m2QIy5U/e7CWytlskrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717097915; c=relaxed/simple;
	bh=Ix6gwD7X6uDMEin5J9xf8KorDYnrCNICaYsuoYTfabk=;
	h=Date:To:From:Subject:Message-Id; b=qHHw/B+S3zoLqgM2HzY7DzTbtitfibDB2/OWFTlmAsQEwBCOnY0Uww2R1J1Oi8W1DyuYrmWJFZVGgEDkj3kGPUTsbT02VMTQno2XCZHYDOgaCD4ury1UJZkhGWM4chNeI3GC424Z3sMTmMFftqJ0VRZ6GDRa6knaiGaj8pTT5gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Na72SnQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Na72SnQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A60CC2BBFC;
	Thu, 30 May 2024 19:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717097914;
	bh=Ix6gwD7X6uDMEin5J9xf8KorDYnrCNICaYsuoYTfabk=;
	h=Date:To:From:Subject:From;
	b=Na72SnQfKDbYXlJtEa6ET1/AFcQYZGFUABDmXF9helpnxCYxrTbhKOxN+EElU97m5
	 PGz9eyTBSMOFBin+ngMQu00W3HAzBxfmaqzBwNzkq+KOfT6qXdNtux5AWPRg6s9rDF
	 Wtk1xskwqMa2lsqyhiFEmOKxhbLxbc2y4fVpVxQQ=
Date: Thu, 30 May 2024 12:38:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch added to mm-hotfixes-unstable branch
Message-Id: <20240530193834.7A60CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential kernel bug due to lack of writeback flag waiting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential kernel bug due to lack of writeback flag waiting
Date: Thu, 30 May 2024 23:15:56 +0900

Destructive writes to a block device on which nilfs2 is mounted can cause
a kernel bug in the folio/page writeback start routine or writeback end
routine (__folio_start_writeback in the log below):

 kernel BUG at mm/page-writeback.c:3070!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
 ...
 RIP: 0010:__folio_start_writeback+0xbaa/0x10e0
 Code: 25 ff 0f 00 00 0f 84 18 01 00 00 e8 40 ca c6 ff e9 17 f6 ff ff
  e8 36 ca c6 ff 4c 89 f7 48 c7 c6 80 c0 12 84 e8 e7 b3 0f 00 90 <0f>
  0b e8 1f ca c6 ff 4c 89 f7 48 c7 c6 a0 c6 12 84 e8 d0 b3 0f 00
 ...
 Call Trace:
  <TASK>
  nilfs_segctor_do_construct+0x4654/0x69d0 [nilfs2]
  nilfs_segctor_construct+0x181/0x6b0 [nilfs2]
  nilfs_segctor_thread+0x548/0x11c0 [nilfs2]
  kthread+0x2f0/0x390
  ret_from_fork+0x4b/0x80
  ret_from_fork_asm+0x1a/0x30
  </TASK>

This is because when the log writer starts a writeback for segment summary
blocks or a super root block that use the backing device's page cache, it
does not wait for the ongoing folio/page writeback, resulting in an
inconsistent writeback state.

Fix this issue by waiting for ongoing writebacks when putting
folios/pages on the backing device into writeback state.

Link: https://lkml.kernel.org/r/20240530141556.4411-1-konishi.ryusuke@gmail.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/segment.c~nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting
+++ a/fs/nilfs2/segment.c
@@ -1652,6 +1652,7 @@ static void nilfs_segctor_prepare_write(
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio) {
 					folio_lock(bd_folio);
+					folio_wait_writeback(bd_folio);
 					folio_clear_dirty_for_io(bd_folio);
 					folio_start_writeback(bd_folio);
 					folio_unlock(bd_folio);
@@ -1665,6 +1666,7 @@ static void nilfs_segctor_prepare_write(
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_folio != bd_folio) {
 					folio_lock(bd_folio);
+					folio_wait_writeback(bd_folio);
 					folio_clear_dirty_for_io(bd_folio);
 					folio_start_writeback(bd_folio);
 					folio_unlock(bd_folio);
@@ -1681,6 +1683,7 @@ static void nilfs_segctor_prepare_write(
 	}
 	if (bd_folio) {
 		folio_lock(bd_folio);
+		folio_wait_writeback(bd_folio);
 		folio_clear_dirty_for_io(bd_folio);
 		folio_start_writeback(bd_folio);
 		folio_unlock(bd_folio);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch

