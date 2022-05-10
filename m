Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DF0C43219
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiEJEWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiEJEUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A3E2F012
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAA3D61770
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4E3C385C2;
        Tue, 10 May 2022 04:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156146;
        bh=m1oWM8/VjV/IywBJZzD9T06d4I4R7SuWFJwIvtF+beY=;
        h=Date:To:From:Subject:From;
        b=FCFUYxpPZfCduYNoKgIwcYSQ1/JOVNw+lQUYiSaS33qAi8xcxdmzSyqOwLuzT0JP0
         pDgm2EOX/dOwgi4jBXqauCulaJQsHny4gQ/pWtpAj2nUG2SUsQnt4OnSK/gu+JY1RN
         5btHWjQITv/pvipx/lc4eyy7r2yesvtSzVLc68FI=
Date:   Mon, 09 May 2022 21:15:45 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, dossche.niels@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch removed from -mm tree
Message-Id: <20220510041546.0C4E3C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest/vm: test that mremap fails on non-existent vma
has been removed from the -mm tree.  Its filename was
     selftest-vm-test-that-mremap-fails-on-non-existent-vma.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Niels Dossche <dossche.niels@gmail.com>
Subject: selftest/vm: test that mremap fails on non-existent vma

Add a regression test that validates that mremap fails for vma's that
don't exist.

Link: https://lkml.kernel.org/r/20220427224439.23828-3-dossche.niels@gmail.com
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftest-vm-test-that-mremap-fails-on-non-existent-vma
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -178,6 +178,12 @@ int main(int argc, char *argv[])
 
 	munmap(addr, length);
 
+	addr = mremap(addr, length, length, 0);
+	if (addr != MAP_FAILED) {
+		printf("mremap: Expected failure, but call succeeded\n");
+		exit(1);
+	}
+
 	close(fd);
 	unlink(argv[argc-1]);
 
_

Patches currently in -mm which might be from dossche.niels@gmail.com are


