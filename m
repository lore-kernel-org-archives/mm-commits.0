Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEA1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D3161362
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhKEUqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C10D061357;
        Fri,  5 Nov 2021 20:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145019;
        bh=A1b8T3O1T0WocifxUVe3XDB6mxulsM/WPJ8ZXiLYRy4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u3faRA7HpsYo4pkZtNx87bc/4o+AqbWN73KVDdAIiVS6eVjJqnAN8cNKfwRz2Jd/u
         DSZoRnJjoTvgrTfc1eFw15gVqYWB2k08X9WJlgjI2+IXsosUJF9WfPTSvURQbGXIVK
         zeu37hWkUUD+cHQGDgjGOR4f/vyQRpQrAp5vtAyY=
Date:   Fri, 05 Nov 2021 13:43:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davis.george@siemens.com,
        erosca@de.adit-jv.com, koct9i@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject:  [patch 172/262] selftests/vm/transhuge-stress: fix ram
 size thinko
Message-ID: <20211105204338.945CWO140%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
