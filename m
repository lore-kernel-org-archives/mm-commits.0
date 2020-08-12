Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E07AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA6620658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196179;
	bh=OXkFYqDQrDZwLwkEZLN2oq/Qe37Bh9l2JW/wnnhYcp0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bi7tnvWUi8w1napviUDwggUJ7Fj6H7Ue0Gz2cruanO0TXelEN5QcsMbCz/lPz6CGy
	 BbtQcII17xe0dXeyGIDyLJHd0txqLw1ffFdGwkxJ0B2xcIJiwxLxXRZji53SxBBqXp
	 v7oI2JmZWDu1U+pU6HLrpKkA0iJbZTNGCNfpBrcI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752F020678;
        Wed, 12 Aug 2020 01:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196177;
        bh=OXkFYqDQrDZwLwkEZLN2oq/Qe37Bh9l2JW/wnnhYcp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cL2eIYCtY+fPMamgj8wEfIfNrdFRl22tOF+pVACX+9tXWfVPr082t4lhVL9z/zHuZ
         0ryBZ6ADik9QVjsMeq9/vL8nqTwi0qe5G0ycx7PPu34eR2XXjgcc7pDSW0HTpLYGY8
         tdliaPJPEgpPK4RozHfg3VlRxaSV4DxFQZoCU4Eo=
Date:   Tue, 11 Aug 2020 18:36:16 -0700
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
Subject:  [patch 114/165] test_kmod: avoid potential double free in
 trigger_config_run_type()
Message-ID: <20200812013616.O9SnvlJDt%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
