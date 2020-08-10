Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4902BC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C447206E9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026845;
	bh=fAKP3VlUMHlr1b9WNVVtNzkGotX2RHk+vCPjXrfbC9g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ATTsAHvanvZFFufW+GY4LfoujqhTOq/+XMC0vqWJ0DOPtvALWWnIJF/UnJ0LwyvtJ
	 eOJMvxtDbt1BHBcsiWAYfJxLIlgVisiu1c7bBs6iDKdYHPzuIZ9EaYi0ORpbxOMQf+
	 4rFFKnAvDn+1UjF0EppzFMzQHt+9BiDaZMRJVbGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCeE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A26F206C3;
        Mon, 10 Aug 2020 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026844;
        bh=fAKP3VlUMHlr1b9WNVVtNzkGotX2RHk+vCPjXrfbC9g=;
        h=Date:From:To:Subject:From;
        b=mV2DJuaTeSb78cqA9tZFnjwL5g/DRV/PC6GtXUEb0ay2HlbqwVMwxwSG0jXZMFWjV
         Q9+jwsU1JojGSSgepOoJBdhnyiSzOba54iNvYUIctd7HuABuF6G+nAER28M4BGtCir
         1cMjFXrN05ICAAw9PwFcSjGvYBxxNbfAf+9BDXA0=
Date:   Sun, 09 Aug 2020 19:34:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nborisov@suse.com
Subject:  [merged]
 bloat-o-meter-support-comparing-library-archives.patch removed from -mm
 tree
Message-ID: <20200810023404.TiZotvwSQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: Support comparing library archives
has been removed from the -mm tree.  Its filename was
     bloat-o-meter-support-comparing-library-archives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: scripts/bloat-o-meter: Support comparing library archives

Library archives (.a) usually contain multiple object files so their
output of nm --size-sort contains lines like:

<omitted for brevity>
00000000000003a8 t run_test

extent-map-tests.o:
<omitted for brevity>

bloat-o-meter currently doesn't handle them which results in errors when
calling .split() on them.  Fix this by simply ignoring them.  This enables
diffing subsystems which generate built-in.a files.

Link: http://lkml.kernel.org/r/20200603103513.3712-1-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/bloat-o-meter~bloat-o-meter-support-comparing-library-archives
+++ a/scripts/bloat-o-meter
@@ -26,6 +26,8 @@ def getsizes(file, format):
     sym = {}
     with os.popen("nm --size-sort " + file) as f:
         for line in f:
+            if line.startswith("\n") or ":" in line:
+                continue
             size, type, name = line.split()
             if type in format:
                 # strip generated symbols
_

Patches currently in -mm which might be from nborisov@suse.com are


