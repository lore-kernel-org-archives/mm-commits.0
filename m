Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1904CC433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D50B2221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781381;
	bh=AAmWkQvvZBKmqp4aVbr8oXCk1LrZkBLh/2YaYAxgK/U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=04DbZrMWxWdq10sS+vwJ9Wo16Kh4roKu2/CWK/zX7aBttoCPgXVLTtl7odCEXBCou
	 hOFFm+kIDk0ylMRknQHwpXLtUE+5wa+kRTSFF/y2If2xia1NaEzwrnsgSZQwO5i+TH
	 oVPKm9Jgs73Wfm/L32mTMoojsPcBSZbvPv6JuvWU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 585CB22C9F;
        Fri,  7 Aug 2020 06:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781380;
        bh=AAmWkQvvZBKmqp4aVbr8oXCk1LrZkBLh/2YaYAxgK/U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Cj30MXfiy9vJN/28rFSojY1S7+uKUeVky0Nee9JE3nGxA+jXmfIWGvsJRxTDZPyXI
         wUsiVETGTDVNMS9QQqwrH04DudmDsq0X2hovoxkyHsOFGgfcbFRhY9wkkQtSk5Km1P
         6wSoPu2LEm3aYm8+mvPaDH+83jgJASTNaChtHx7s=
Date:   Thu, 06 Aug 2020 23:22:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 104/163] mm/mmap: optimize a branch judgment in
 ksys_mmap_pgoff()
Message-ID: <20200807062259.JNE-ENp6G%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()

Look at the pseudo code below.  It's very clear that, the judgement
"!is_file_hugepages(file)" at 3) is duplicated to the one at 1), we can
use "else if" to avoid it.  And the assignment "retval = -EINVAL" at 2) is
only needed by the branch 3), because "retval" will be overwritten at 4).

No functional change, but it can reduce the code size. Maybe more clearer?
Before:
text    data     bss     dec     hex filename
28733    1590       1   30324    7674 mm/mmap.o

After:
text    data     bss     dec     hex filename
28701    1590       1   30292    7654 mm/mmap.o

====pseudo code====:
	if (!(flags & MAP_ANONYMOUS)) {
		...
1)		if (is_file_hugepages(file))
			len = ALIGN(len, huge_page_size(hstate_file(file)));
2)		retval = -EINVAL;
3)		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
			goto out_fput;
	} else if (flags & MAP_HUGETLB) {
		...
	}
	...

4)	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
out_fput:
	...
	return retval;

Link: http://lkml.kernel.org/r/20200705080112.1405-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1562,11 +1562,12 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		file = fget(fd);
 		if (!file)
 			return -EBADF;
-		if (is_file_hugepages(file))
+		if (is_file_hugepages(file)) {
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
-		retval = -EINVAL;
-		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
+		} else if (unlikely(flags & MAP_HUGETLB)) {
+			retval = -EINVAL;
 			goto out_fput;
+		}
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		struct hstate *hs;
_
