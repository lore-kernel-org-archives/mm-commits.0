Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A3EC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345398AbiCWXHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiCWXHq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF24990CCF
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F83B82181
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65987C340E8;
        Wed, 23 Mar 2022 23:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076772;
        bh=pXxe4GoU2D3A9KWBwr5wb4WM0HFwzyMO1uZb/t9+YMQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mQm4bFUdf8SEoKXuY25vFShuF/EU4CWJ48C72TJjKc7LPSl55ctRfka5qXtzLAGxx
         iSUd2SiTFCfAnTIpVveRlSFR3JBFLTtMOegdLsu2aNWz5xapSPmHYKqrzsQK06G8Nk
         r7XY6IVBX061JkUx37pRj+HF8F0QTpCNLbNl1aNs=
Date:   Wed, 23 Mar 2022 16:06:11 -0700
To:     mingo@kernel.org, i.zhbanov@omprussia.ru,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 18/41] init.h: improve __setup and early_param documentation
Message-Id: <20220323230612.65987C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: init.h: improve __setup and early_param documentation

Igor noted in [1] that there are quite a few __setup() handling functions
that return incorrect values.  Doing this can be harmless, but it can also
cause strings to be added to init's argument or environment list,
polluting them.

Since __setup() handling and return values are not documented, first add
documentation for that.  Also add more documentation for early_param()
handling and return values.

For __setup() functions, returning 0 (not handled) has questionable
value if it is just a malformed option value, as in
  rodata=junk
since returning 0 would just cause "rodata=junk" to be added to init's
environment unnecessarily:
  Run /sbin/init as init process
    with arguments:
      /sbin/init
    with environment:
      HOME=/
      TERM=linux
      splash=native
      rodata=junk

Also, there are no recommendations on whether to print a warning when an
unknown parameter value is seen.  I am not addressing that here.

[1] lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru

Link: https://lkml.kernel.org/r/20220221050852.1147-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/init.h~inith-improve-__setup-and-early_param-documentation
+++ a/include/linux/init.h
@@ -320,12 +320,19 @@ struct obs_kernel_param {
 		__aligned(__alignof__(struct obs_kernel_param))		\
 		= { __setup_str_##unique_id, fn, early }
 
+/*
+ * NOTE: __setup functions return values:
+ * @fn returns 1 (or non-zero) if the option argument is "handled"
+ * and returns 0 if the option argument is "not handled".
+ */
 #define __setup(str, fn)						\
 	__setup_param(str, fn, fn, 0)
 
 /*
- * NOTE: fn is as per module_param, not __setup!
- * Emits warning if fn returns non-zero.
+ * NOTE: @fn is as per module_param, not __setup!
+ * I.e., @fn returns 0 for no error or non-zero for error
+ * (possibly @fn returns a -errno value, but it does not matter).
+ * Emits warning if @fn returns non-zero.
  */
 #define early_param(str, fn)						\
 	__setup_param(str, fn, fn, 1)
_
