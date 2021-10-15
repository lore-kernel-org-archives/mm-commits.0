Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C047FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB1861151
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhJOTba (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238415AbhJOTb0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEED961184;
        Fri, 15 Oct 2021 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634326159;
        bh=Lane3irBWgGCZtJ/tcMEcf9yCGHgS3pY3ZUBG8XL+bg=;
        h=Date:From:To:Subject:From;
        b=UGVXkbHW9JbWKCabgSy5tJvDK0r5S0uyXbpwJCJhyCpEAkJcCjRVOXLzxurDhXIJ6
         WUiLOxYoJSOuc7jE/JgW2qVs8G5Trr7XTh6ZVcsMUT/Za3oJ7QycorHCsrON73jCwE
         jDRy0hv1tNkTdakystoLSUFq7+1caa6q2sGLOFr8=
Date:   Fri, 15 Oct 2021 12:29:19 -0700
From:   akpm@linux-foundation.org
To:     davis.george@siemens.com, erosca@de.adit-jv.com, koct9i@gmail.com,
        mm-commits@vger.kernel.org, skhan@linuxfoundation.org
Subject:  + selftests-vm-transhuge-stress-fix-ram-size-thinko.patch
 added to -mm tree
Message-ID: <20211015192919.OtdIDOPiW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/transhuge-stress: fix ram size thinko
has been added to the -mm tree.  Its filename is
     selftests-vm-transhuge-stress-fix-ram-size-thinko.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-transhuge-stress-fix-ram-size-thinko.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-transhuge-stress-fix-ram-size-thinko.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George G. Davis" <davis.george@siemens.com>
Subject: selftests/vm/transhuge-stress: fix ram size thinko

When executing transhuge-stress with an argument to specify the virtual
memory size for testing, the ram size is reported as 0, e.g.

transhuge-stress 384
thp-mmap: allocate 192 transhuge pages, using 384 MiB virtual memory and 0 MiB of ram
thp-mmap: 0.184 s/loop, 0.957 ms/page,   2090.265 MiB/s  192 succeed,    0 failed

This appears to be due to a thinko in commit 0085d61fe05e
("selftests/vm/transhuge-stress: stress test for memory compaction"),
where, at a guess, the intent was to base "xyz MiB of ram" on `ram` size. 
Here are results after using `ram` size:

thp-mmap: allocate 192 transhuge pages, using 384 MiB virtual memory and 14 MiB of ram

Link: https://lkml.kernel.org/r/20210825135843.29052-1-george_davis@mentor.com
Fixes: 0085d61fe05e ("selftests/vm/transhuge-stress: stress test for memory compaction")
Signed-off-by: George G. Davis <davis.george@siemens.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/transhuge-stress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/transhuge-stress.c~selftests-vm-transhuge-stress-fix-ram-size-thinko
+++ a/tools/testing/selftests/vm/transhuge-stress.c
@@ -79,7 +79,7 @@ int main(int argc, char **argv)
 
 	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
 	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
-	      len >> (20 + HPAGE_SHIFT - PAGE_SHIFT - 1));
+	      ram >> (20 + HPAGE_SHIFT - PAGE_SHIFT - 1));
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
_

Patches currently in -mm which might be from davis.george@siemens.com are

selftests-vm-transhuge-stress-fix-ram-size-thinko.patch

