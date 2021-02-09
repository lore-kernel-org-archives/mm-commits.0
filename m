Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32896C433E6
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B89964DEC
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhBIW2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:28:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhBIWMP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE7564ED5;
        Tue,  9 Feb 2021 21:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906942;
        bh=LhrEa46rTAlqYXz+fnHb+GOfsNWXuoInvZlrVTLXNsg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o/ST+x0gGOxvFNVDuEsr/tdgkTtRXhSOx1mkU1nM+rD1BEMPVI9FwFma1AJN3LoJ8
         biRDUTnZaSKUvpcv4ZFr75V8WvhQY8Hzv5B2Ne7dKBCXRThYGpSVMFDVBXleRwWGK9
         UXtxzPNTYFs9KhiR+bwC7T+/v7ynwWEZDxntrYqI=
Date:   Tue, 09 Feb 2021 13:42:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        lkp@intel.com, mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 10/14] selftests/vm: rename file run_vmtests to
 run_vmtests.sh
Message-ID: <20210209214221.ge_x1EsLw%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rong Chen <rong.a.chen@intel.com>
Subject: selftests/vm: rename file run_vmtests to run_vmtests.sh

Commit c2aa8afc36fa has renamed run_vmtests in Makefile, but the file
still uses the old name.

The kernel test robot reported the following issue:

 # selftests: vm: run_vmtests.sh
 # Warning: file run_vmtests.sh is missing!
 not ok 1 selftests: vm: run_vmtests.sh

Link: https://lkml.kernel.org/r/20210205085507.1479894-1-rong.a.chen@intel.com
Fixes: c2aa8afc36fa (selftests/vm: rename run_vmtests --> run_vmtests.sh)
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/{run_vmtests => run_vmtests.sh} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/testing/selftests/vm/{run_vmtests => run_vmtests.sh} (100%)

diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests.sh
similarity index 100%
rename from tools/testing/selftests/vm/run_vmtests
rename to tools/testing/selftests/vm/run_vmtests.sh

