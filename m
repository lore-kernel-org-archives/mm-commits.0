Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1629AA937;
	Fri,  7 Nov 2025 00:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762475308; cv=none; b=QZYa7eW3GqyLiWB1f+WqD4EbFJcyUpe5FMUlqVYhRmEY8su89ZlcISZFJD0A9ROMtW1krcivM5bZYIKreGKv9j2OxJhTBjPn7AIQ42QZJOkf/iStLr1fyrTbTbNX4uHt7+7liDR4JCHVfwgwz/FZCyPpw5o1dkHiT6shTznr3bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762475308; c=relaxed/simple;
	bh=mAmkpNM6A5qEzYrd+EQWVnt9qsw2gPyNW6zZSqRlbog=;
	h=Date:To:From:Subject:Message-Id; b=VOGJCekUjAfzw08XnshRQYsC48LbpucRKnAjIr4Gt1caZc7lyLMMWw+lHg+Qynx/hz5voHW2TkQj2Yhg3XAANX/10dwnqA3GseiFiyV3g2OtheBz20zcXgUtXCWesnq2zYm+XKIL+rWv/vOSx8zDDCo/PkX7vpHOMdt8OreYq+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1ZL6AZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1ZL6AZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCA1C19422;
	Fri,  7 Nov 2025 00:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762475307;
	bh=mAmkpNM6A5qEzYrd+EQWVnt9qsw2gPyNW6zZSqRlbog=;
	h=Date:To:From:Subject:From;
	b=n1ZL6AZpaDn2/12YXpvum2W2fUFf2r3ih/cqPo0eka2H3LDai6j8/QlSbxCbaf3yd
	 uciPJrHARiKCo+59F/1rIUske+2hR/9Hn+dwVJvYPy+pL9Mi8mbCY8H3QllrHkYVOD
	 I0wnp1lCpnbwkSBMA/Sx7SVEAFJBW18ZRz4MaHa8=
Date: Thu, 06 Nov 2025 16:28:26 -0800
To: mm-commits@vger.kernel.org,sunliming@kylinos.cn,stable@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,mhiramat@kernel.org,beaub@linux.microsoft.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch added to mm-hotfixes-unstable branch
Message-Id: <20251107002827.8DCA1C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/user_events: fix type cast for write_index packed member in perf_test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch

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
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: selftests/user_events: fix type cast for write_index packed member in perf_test
Date: Thu, 6 Nov 2025 15:25:32 +0530

Accessing 'reg.write_index' directly triggers a -Waddress-of-packed-member
warning due to potential unaligned pointer access:

perf_test.c:239:38: warning: taking address of packed member 'write_index'
of class or structure 'user_reg' may result in an unaligned pointer value
[-Waddress-of-packed-member]
  239 |         ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
      |                                             ^~~~~~~~~~~~~~~

Since write(2) works with any alignment. Casting '&reg.write_index'
explicitly to 'void *' to suppress this warning.

Link: https://lkml.kernel.org/r/20251106095532.15185-1-ankitkhushwaha.linux@gmail.com
Fixes: 42187bdc3ca4 ("selftests/user_events: Add perf self-test for empty arguments events")
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: sunliming <sunliming@kylinos.cn>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/user_events/perf_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/user_events/perf_test.c~selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test
+++ a/tools/testing/selftests/user_events/perf_test.c
@@ -236,7 +236,7 @@ TEST_F(user, perf_empty_events) {
 	ASSERT_EQ(1 << reg.enable_bit, self->check);
 
 	/* Ensure write shows up at correct offset */
-	ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
+	ASSERT_NE(-1, write(self->data_fd, (void *)&reg.write_index,
 					sizeof(reg.write_index)));
 	val = (void *)(((char *)perf_page) + perf_page->data_offset);
 	ASSERT_EQ(PERF_RECORD_SAMPLE, *val);
_

Patches currently in -mm which might be from ankitkhushwaha.linux@gmail.com are

selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch

