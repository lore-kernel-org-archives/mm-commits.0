Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1897C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8EC22C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781053;
	bh=c7aI5CAH4MJlD2dGZs2NQx1mLlEILlnOB/MkFg9trag=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hh9ayTuagSbcZMV8pQkvQvWs2xi4iiiUksxo+hnSXMgkICKUsrEyayYR+SvgMwdLy
	 6X0XGTzMDJgPN6EU7kP8aojAbB3PtXQmug37bjL6vZx9FVA5dhKKbLiTxE4ZKHg+BL
	 +3UUI9rnoUAi9Mqfs8sS+5FJ4tvJQSDzKaOvv9ig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHGGRd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA498221E5;
        Fri,  7 Aug 2020 06:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781052;
        bh=c7aI5CAH4MJlD2dGZs2NQx1mLlEILlnOB/MkFg9trag=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IZXoWJ+bpAJ7DPs3laGkU7B1mjJ087S2/0G33JvN1X6QkIKiQcA3sogyD3orzkJV3
         q6NTod296MTWV3L0BONW/U4zzBK1Vei2Ar73OYmL9l4yFOqa3PUlywb08KZYVvTQmu
         Vpv5VdkE0yZPLxKSI79//OOZzEAKFbHVAm9d9EJs=
Date:   Thu, 06 Aug 2020 23:17:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nborisov@suse.com,
        torvalds@linux-foundation.org
Subject:  [patch 009/163] scripts/bloat-o-meter: Support comparing
 library archives
Message-ID: <20200807061732.dXHNntoww%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
