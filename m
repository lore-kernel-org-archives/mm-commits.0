Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ABFEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjFSXUt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjFSXUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C0E65
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74ACA60F39
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4EBC433C8;
        Mon, 19 Jun 2023 23:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216833;
        bh=Hpfbfjb86uQCsr06xX+kvUaHVAJZGFD3zsHpU064GmY=;
        h=Date:To:From:Subject:From;
        b=SQfiGpwTxZ9IQTQ+2b/tReWgbxkHgkYP8E8gaiPXcJHm4j0y8TaMG8tSs5M25HfvQ
         Fzinsf3H+rlcVogpQ/yKCFE/vHHidpfsY506urHr4KyIDzIvJ0IXYBSHsQLseHCFoB
         mmdg2iAy6P0FSidBiUvzG8X7N4qrlFeFQIZtM5AU=
Date:   Mon, 19 Jun 2023 16:20:33 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-kselftest-make-headers-is-a-prerequisite.patch removed from -mm tree
Message-Id: <20230619232033.CB4EBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: kselftest: "make headers" is a prerequisite
has been removed from the -mm tree.  Its filename was
     documentation-kselftest-make-headers-is-a-prerequisite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: Documentation: kselftest: "make headers" is a prerequisite
Date: Tue, 6 Jun 2023 00:16:36 -0700

As per a discussion with Muhammad Usama Anjum [1], the following is how
one is supposed to build selftests:

    make headers && make -C tools/testing/selftests/mm

However, that's not yet documented anywhere. So add it to
Documentation/dev-tools/kselftest.rst .

[1] https://lore.kernel.org/all/bf910fa5-0c96-3707-cce4-5bcc656b6274@collabora.com/

Link: https://lkml.kernel.org/r/20230606071637.267103-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kselftest.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/dev-tools/kselftest.rst~documentation-kselftest-make-headers-is-a-prerequisite
+++ a/Documentation/dev-tools/kselftest.rst
@@ -36,6 +36,7 @@ Running the selftests (hotplug tests are
 
 To build the tests::
 
+  $ make headers
   $ make -C tools/testing/selftests
 
 To run the tests::
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


