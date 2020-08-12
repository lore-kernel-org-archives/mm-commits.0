Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0BFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9169A20678
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196170;
	bh=9LXyg1k+FiZHPruHM2A6j0cghxQIG5oHc8g2DhrV0Ek=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sX9Mleaxy2dleFZUWG6hr8R7EsFqcMN2Ahx0jV9A/VCEGXELhfjny1zAliVRA5Zlg
	 XfLM3BoHt7GjGr8t93PRfCpCNfJJTRxM+lykY2neKeHFEMtC2NLy5WFXgJHmJlpici
	 RlGcPiPFQnXXVuwJ5NKq3HG+YwJRSkEasA/0fPLY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FE4A20658;
        Wed, 12 Aug 2020 01:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196169;
        bh=9LXyg1k+FiZHPruHM2A6j0cghxQIG5oHc8g2DhrV0Ek=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mAdhr6DSC1CENx8liekQkn9P8Wub/dYdYEbZmz8Qq/imD5v+mlirKngjFHpCjWqfU
         qLycjMcXDunmgVHKaqDBxR+xI0vtUmzhjuXh7vQwv6lSR79/M9TAvfjN/EiF/ZkUCJ
         sscL12sOtwe2CiVVRsIQiG1OvignQoDCOcJ0pxj0=
Date:   Tue, 11 Aug 2020 18:36:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ast@kernel.org, axboe@kernel.dk,
        bfields@fieldses.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-mm@kvack.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, shuah@kernel.org,
        slyfox@gentoo.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn
Subject:  [patch 112/165] selftests: kmod: use variable NAME in
 kmod_test_0001()
Message-ID: <20200812013608.cmO42BB7q%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: selftests: kmod: use variable NAME in kmod_test_0001()

Patch series "kmod/umh: a few fixes".

Tiezhu Yang had sent out a patch set with a slew of kmod selftest fixes,
and one patch which modified kmod to return 254 when a module was not
found.  This opened up pandora's box about why that was being used for and
low and behold its because when UMH_WAIT_PROC is used we call a
kernel_wait4() call but have never unwrapped the error code.  The commit
log for that fix details the rationale for the approach taken.  I'd
appreciate some review on that, in particular nfs folks as it seems a case
was never really hit before.


This patch (of 5):

Use the variable NAME instead of "\000" directly in kmod_test_0001().

Link: http://lkml.kernel.org/r/20200610154923.27510-1-mcgrof@kernel.org
Link: http://lkml.kernel.org/r/20200610154923.27510-2-mcgrof@kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kmod/kmod.sh~selftests-kmod-use-variable-name-in-kmod_test_0001
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -343,7 +343,7 @@ kmod_test_0001_driver()
 
 	kmod_defaults_driver
 	config_num_threads 1
-	printf '\000' >"$DIR"/config_test_driver
+	printf $NAME >"$DIR"/config_test_driver
 	config_trigger ${FUNCNAME[0]}
 	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
 }
@@ -354,7 +354,7 @@ kmod_test_0001_fs()
 
 	kmod_defaults_fs
 	config_num_threads 1
-	printf '\000' >"$DIR"/config_test_fs
+	printf $NAME >"$DIR"/config_test_fs
 	config_trigger ${FUNCNAME[0]}
 	config_expect_result ${FUNCNAME[0]} -EINVAL
 }
_
