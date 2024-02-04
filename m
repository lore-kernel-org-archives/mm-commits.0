Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A059479
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031259; cv=none; b=PFSvgQEiPz0LZBupN09U9EfTbK6PF49xAAvWyRzU+KzkK/jKhPissK1BPsAyAAOMpxKQwTgU6PmENg8RLNeY1+hSkSyY6LgMjdHD2XtODR4EdPQa78EWpiBAHl68yn9mjKYBy72oJ3Rv6+eS99CAtQBNh0F3sOvA327LSya8T3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031259; c=relaxed/simple;
	bh=c5CsFhWa4M6TbG8vYd3Jt48foibBfq3eaq4D1iLTJV8=;
	h=Date:To:From:Subject:Message-Id; b=IYUgnOEuwyWxAirNJhf+bHoWfHV0Ujt225UvECUCBEB5ZM4zV8Z5AVJFSgLWE6etBAEMQsl7S8xCIkfT40s7bpmRrTwEWGW/PQ42X+8KmBRnaooj5vcf2Z8+do2eprENjiyddg88juoNCVmUBvW9BwD9Pghtu3Hh7Q+PMWN1trY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CK3H4MFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CK3H4MFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB365C43390;
	Sun,  4 Feb 2024 07:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031258;
	bh=c5CsFhWa4M6TbG8vYd3Jt48foibBfq3eaq4D1iLTJV8=;
	h=Date:To:From:Subject:From;
	b=CK3H4MFO/C+I7OGjH0uQeJDLId1paxGwQ8iqohIj+fAREb7o7tWZTMNPh+CAHHOrt
	 HkE+gWmlr/jbUlWPSHc5jdbV79O6QI7yEF8fytqB8lkQgzYIlRY02XfCiUTLyxPlG0
	 YOLU0b/6PPdxAnTd210pCui67qVWA9mVNkKz66G0=
Date: Sat, 03 Feb 2024 23:20:58 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch added to mm-unstable branch
Message-Id: <20240204072058.AB365C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
Date: Sat Feb  3 06:10:51 AM PST 2024

s/comnst/const/

Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
+++ a/mm/damon/dbgfs.c
@@ -810,7 +810,7 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	static comnst char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
+	static const char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
 
 	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

