Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A5818654;
	Thu,  6 Jun 2024 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640410; cv=none; b=KRAdc0NYv4RSI+NkrlnJWMNm79jEznK4Ihbyhe3GMtG9aAMMaf8hEIRwGqA+qOBSJa44EB5F1ohJ/ZtU59pwovX+e4Sap5SRqMuozGrY+tH/bWVQH/7hCUXZfA2unIsCDKIna+OYjuJB06oDd6m5qv/taVrw/l6eKSPqLU+BKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640410; c=relaxed/simple;
	bh=Ai+A38rvnVUgFTr9WCDbIXiWSnKGLWF/lrnyFF/MMoE=;
	h=Date:To:From:Subject:Message-Id; b=GzyC7OInCmDcmvZV9L1WrK0DCpwNNymC1u/S5BeTZVkduVSJdzlxyCQZLfWxjEXiu6DpmqUQ28bCmPkaOGquW8NsWVSsnPKtlHTU70oAI7j+aHSmTF9KMF0upQGff+3/JePo92KTz/XsOX43+0OjqjtMbfWaEdb5Qrdf0auf2BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fg7ZqAw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fg7ZqAw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116CEC4AF09;
	Thu,  6 Jun 2024 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640410;
	bh=Ai+A38rvnVUgFTr9WCDbIXiWSnKGLWF/lrnyFF/MMoE=;
	h=Date:To:From:Subject:From;
	b=Fg7ZqAw7hE5c79M9IHWhegnmr1rCHnHoUazyelcCiiXVEb6VwEZ+e8TQmEL0CeENv
	 vHqDbL1vI1prysgz0h3+HyIiK2DMqqxODQAbht8rBqr+LKqJ2exJSBzKbjTUdlaDas
	 99B4TwjfFoOFtIssfc6s7BWwPobL2KJALKp6M1YQ=
Date: Wed, 05 Jun 2024 19:20:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch removed from -mm tree
Message-Id: <20240606022010.116CEC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix potential kernel bug due to lack of writeback flag waiting
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-kernel-bug-due-to-lack-of-writeback-flag-waiting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


