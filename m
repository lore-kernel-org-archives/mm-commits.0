Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0338D1C3F0E
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327879; cv=none; b=HSX3KEaoYEqd65jorNkBlex0MFZJ7Bibi70UQ3FxvCFE4MPSyi+BBicVV2WH/YGOQMz5l3z43ayRbQj5Ff9wRA9mfRSw+gaLzMLX7IHmOul5XxRdHr2qvg+s7bhiXxEsALZLHd5e15tHykTuHmkZNunKRRdxsFkag7KHbv4hjIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327879; c=relaxed/simple;
	bh=Wfzff9Q4RgijfkUhHOa0DwF9om10ctIpz8fbWPFIs/E=;
	h=Date:To:From:Subject:Message-Id; b=uILYRUMZkUrYkCUbBxyOyLlw9gNg4V9Cb/UrwtKo7fNWjYQWFPNLtWZiXNFvQ5L/5zLYyu464AE5rfmpdbXuTIlkpzJyUpKKVrwoS84yJTbtVEGBE+Yz2jaqNO5rK1AGjsNuIn/58i4dYkzsaQNi/AiRxKKflyhxugbWWic1LsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NOiNqEAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NOiNqEAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A16C4CED0;
	Mon, 16 Dec 2024 05:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327878;
	bh=Wfzff9Q4RgijfkUhHOa0DwF9om10ctIpz8fbWPFIs/E=;
	h=Date:To:From:Subject:From;
	b=NOiNqEAQpfjwZ0vu+cSgr5bORvi8HKpUpTfPEGLHOf/TkRIMRFUVHzWPddgMl1P6e
	 rWNxz800YuOZMiE/m87NY9Ue2PZHp3mKohUlLDfF5jwoFUCLIDa+JSNC3+bwum7uNP
	 DAruhl05Y+6jWG+HN0NWtLIiqSYdkWct0SEf0Nm4=
Date: Sun, 15 Dec 2024 21:44:37 -0800
To: mm-commits@vger.kernel.org,leocstone@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-handle-strsep-not-finding-delimiter.patch added to mm-hotfixes-unstable branch
Message-Id: <20241216054438.79A16C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: handle strsep not finding delimiter
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-handle-strsep-not-finding-delimiter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-handle-strsep-not-finding-delimiter.patch

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

mm-huge_memory-handle-strsep-not-finding-delimiter.patch

