Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D078E8633C
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577544; cv=none; b=Ce/jMCTcQwFPsPTkVMwXcUrkENBYbd2NusS4W1cn/mBITnILDUgXwlBeYUB0/Rl+FQ157ar0OBsJUHPkiycfaUl2nb9ppErIYS0hczXrEfoTguncZCyZsx2pIM9gA0A8okIIR37dX1AUN3RgB/0mAfQJnX8HW+7GqCvW08yd0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577544; c=relaxed/simple;
	bh=LfMBowuA9gAFOuaCJAqAjSfghqTlxG7WjZr/LBhViF8=;
	h=Date:To:From:Subject:Message-Id; b=NntItcpU4JnS/exNjK7Ub0AUVLrcrMsq8gl8Ys4gadtAOlXAZpvku6zyziMZZW73E3gjGJVTtv8SyfuyJbaVtRD/1/mGs3cuOr8rHTmfwuCgFQeDzgtcBvO9/vCTQ5EVCZAERDH5I/dqD89zWcKI32f6hVwWFTHxfQX3aJbAris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4Info1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4Info1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D325C4CECD;
	Thu, 19 Dec 2024 03:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577544;
	bh=LfMBowuA9gAFOuaCJAqAjSfghqTlxG7WjZr/LBhViF8=;
	h=Date:To:From:Subject:From;
	b=r4Info1HKQp3sxnguDk164mIUJ4K9T4LD5/32q0KnHDGSLZAP5TNqnEoGN3cb9hK9
	 BiSPS1qGAKfqEdYbUNgTtad5H/cPG5Rv68lUSjpSVLCLvKL2B7zsJLmuG8lZRIJIW/
	 slLkYE1nFJUW+81DYe+9ZvFLh8gp+1Ao/4P9pHe0=
Date: Wed, 18 Dec 2024 19:05:43 -0800
To: mm-commits@vger.kernel.org,leocstone@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-handle-strsep-not-finding-delimiter.patch removed from -mm tree
Message-Id: <20241219030544.5D325C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: handle strsep not finding delimiter
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-handle-strsep-not-finding-delimiter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leo Stone <leocstone@gmail.com>
Subject: mm: huge_memory: handle strsep not finding delimiter
Date: Sun, 15 Dec 2024 20:27:51 -0800

split_huge_pages_write() does not handle the case where strsep finds no
delimiter in the given string and sets the input buffer to NULL, which
allows this reproducer to trigger a protection fault.

Link: https://lkml.kernel.org/r/20241216042752.257090-2-leocstone@gmail.com
Signed-off-by: Leo Stone <leocstone@gmail.com>
Reported-by: syzbot+8a3da2f1bbf59227c289@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8a3da2f1bbf59227c289
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-handle-strsep-not-finding-delimiter
+++ a/mm/huge_memory.c
@@ -4169,7 +4169,7 @@ static ssize_t split_huge_pages_write(st
 		size_t input_len = strlen(input_buf);
 
 		tok = strsep(&buf, ",");
-		if (tok) {
+		if (tok && buf) {
 			strscpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
_

Patches currently in -mm which might be from leocstone@gmail.com are


