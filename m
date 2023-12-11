Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9864421
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KrOnAy2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE8AC433C8;
	Mon, 11 Dec 2023 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256081;
	bh=R3qaCwEzVx/wan8Q28p0YPS9LqZ0dlz3Je9bBh4ltSU=;
	h=Date:To:From:Subject:From;
	b=KrOnAy2WVtoE3q0rYGM1ZqWkgMsOGivaMUjoU6O3r9I0HJ1WEpeIBVqsTmrau3yBx
	 6DnZY4yqsLuFxbGLFWLvG1Zq++3lZvY4jNFfG0muQWP9kngZkuXFDnFl1mgydlDI4x
	 +ssicqQPRnHSSqRzmcjMBP3dvDd7DDkSGiX8l3Ok=
Date: Sun, 10 Dec 2023 16:54:40 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmemleak-add-checksum-to-backtrace-report.patch removed from -mm tree
Message-Id: <20231211005441.6BE8AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmemleak: add checksum to backtrace report
has been removed from the -mm tree.  Its filename was
     kmemleak-add-checksum-to-backtrace-report.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kmemleak: add checksum to backtrace report
Date: Thu, 16 Nov 2023 15:43:18 -0700

Change /sys/kernel/debug/kmemleak report format slightly, adding
"(extra info)" to the backtrace header:

from: "  backtrace:"
to:   "  backtrace (crc <cksum>):"

The <cksum> allows a user to see recurring backtraces without
detailed/careful reading of multiline stacks.  So after cycling
kmemleak-test a few times, I know some leaks are repeating.

  bash-5.2# grep backtrace /sys/kernel/debug/kmemleak | wc
     62     186    1792
  bash-5.2# grep backtrace /sys/kernel/debug/kmemleak | sort -u | wc
     37     111    1067

syzkaller parses kmemleak for "unreferenced object" only, so is
unaffected by this change.  Other github repos are moribund.

Link: https://lkml.kernel.org/r/20231116224318.124209-3-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~kmemleak-add-checksum-to-backtrace-report
+++ a/mm/kmemleak.c
@@ -362,7 +362,7 @@ static void print_unreferenced(struct se
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
 	hex_dump_object(seq, object);
-	warn_or_seq_printf(seq, "  backtrace:\n");
+	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
 		void *ptr = (void *)entries[i];
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


