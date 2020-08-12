Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6364C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3602078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266307;
	bh=y0QEQSRMGGT9nkL9GMyLkmY6tH+3tHz4vJtzpZ5MF2I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ii1vxhT3hgXuyBuXTH08UDt1AXNMtUzSxx6ciSK8V+Ij9NKDNx6sIzujTfkkH2Rzh
	 LTJYzA8zHX/eHfxIuY8XM/MdrADlSOkFDxd4833bGhXLHAEzBbJVC5W/DyQak6c1af
	 Z2L+4Q/Qo+SOLry9LdLMrvp1nslhmovnkvn/ZbDU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHLVFG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgHLVFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A47207F7;
        Wed, 12 Aug 2020 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266305;
        bh=y0QEQSRMGGT9nkL9GMyLkmY6tH+3tHz4vJtzpZ5MF2I=;
        h=Date:From:To:Subject:From;
        b=PotMa308FItlirZAav4i9a3REzDK8ZrfPqntma+fxKfZsuSjB0NgykZDAEXckZaAA
         zjmwgau0FS+Gp4jl35TjxKyIsV8cj4a0kFKqbG5zABAuprXJwte7oz3EY7PJSJKcz/
         rRCAARpec+0HKOryq7pQZEnkZFVdaXLXoV1g6nTw=
Date:   Wed, 12 Aug 2020 14:05:04 -0700
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
 selftests-kmod-use-variable-name-in-kmod_test_0001.patch removed from -mm
 tree
Message-ID: <20200812210504.1QOgTZRtK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: kmod: use variable NAME in kmod_test_0001()
has been removed from the -mm tree.  Its filename was
     selftests-kmod-use-variable-name-in-kmod_test_0001.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


