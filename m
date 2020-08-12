Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E811C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387AB20838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266315;
	bh=ohAEVLvp/RicBq7g4oFtGjYg6A/eEbrcvJmpslreF8w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TcwclWHI0Zde7xJ4dNixa66yW3yI79zJEq/0aA6hqN2esRHTggTx2LDZIVF3s0tuL
	 5jFa93ZySuPdrKWnere3qOy3ojJR3gTjUa4DZs4O8mWwunHI6htnrGA5EO5woEOrYw
	 zQqAQDu3B6DvDObLXnOD5rfImRF2LdD8AwExPnHE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHLVFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgHLVFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC51B20774;
        Wed, 12 Aug 2020 21:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266312;
        bh=ohAEVLvp/RicBq7g4oFtGjYg6A/eEbrcvJmpslreF8w=;
        h=Date:From:To:Subject:From;
        b=GNKdgArDlqsvQ7ExcoNdUgpbAmHv7I01AiVte11YZyjGSMf+Z5+rGuAAmsCinV6gZ
         raQnyQPfY8GA7CYeb04Q6xLRXFLIGWnSm22OoaJ9FtO2I/4sybtCPiTcUVs8gCAznu
         CWNIagghz0xnmOr0BrylmYnIZnnzq3+X6P7aywPs=
Date:   Wed, 12 Aug 2020 14:05:10 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, axboe@kernel.dk, bfields@fieldses.org,
        chainsaw@gentoo.org, christian.brauner@ubuntu.com,
        chuck.lever@oracle.com, davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, shuah@kernel.org,
        slyfox@gentoo.org, viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn
Subject:  [merged]
 test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
 removed from -mm tree
Message-ID: <20200812210510.9i9ip7-nt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_kmod: avoid potential double free in trigger_config_run_type()
has been removed from the -mm tree.  Its filename was
     test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: test_kmod: avoid potential double free in trigger_config_run_type()

Reset the member "test_fs" of the test configuration after a call of the
function "kfree_const" to a null pointer so that a double memory release
will not be performed.

Link: http://lkml.kernel.org/r/20200610154923.27510-4-mcgrof@kernel.org
Fixes: d9c6a72d6fa2 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kmod.c~test_kmod-avoid-potential-double-free-in-trigger_config_run_type
+++ a/lib/test_kmod.c
@@ -745,7 +745,7 @@ static int trigger_config_run_type(struc
 		break;
 	case TEST_KMOD_FS_TYPE:
 		kfree_const(config->test_fs);
-		config->test_driver = NULL;
+		config->test_fs = NULL;
 		copied = config_copy_test_fs(config, test_str,
 					     strlen(test_str));
 		break;
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


