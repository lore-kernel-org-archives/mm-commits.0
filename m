Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E77C001DF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjHDUEe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjHDUEU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C79BE70;
        Fri,  4 Aug 2023 13:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E270662126;
        Fri,  4 Aug 2023 20:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EDAC433C8;
        Fri,  4 Aug 2023 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179459;
        bh=lUqeWm5QYDnYiNkcnFmGQhEjvRNt+F/E1+jIGG18fDw=;
        h=Date:To:From:Subject:From;
        b=XMiWNkvh+OI+ru3KkXm98R80rceryckDXv0wnl16LcSPHVVRDJczL4+xYlH7d9klT
         aplhek0tV7ue2KrZrOpLZ8hIXbxHClM8e6cobrex+9d39pklKgbkg+sI+jsyBnp0qF
         5Cji3VX1j+Tj63KuDISi/AEX+cKpj7X31Vn6gSn0=
Date:   Fri, 04 Aug 2023 13:04:18 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shr@devkernel.io, david@redhat.com, ayush.jain3@amd.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-ksm-fix-incorrect-evaluation-of-parameter.patch removed from -mm tree
Message-Id: <20230804200419.42EDAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: ksm: fix incorrect evaluation of parameter
has been removed from the -mm tree.  Its filename was
     selftests-mm-ksm-fix-incorrect-evaluation-of-parameter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ayush Jain <ayush.jain3@amd.com>
Subject: selftests: mm: ksm: fix incorrect evaluation of parameter
Date: Fri, 28 Jul 2023 22:09:51 +0530

A missing break in kms_tests leads to kselftest hang when the parameter -s
is used.

In current code flow because of missing break in -s, -t parses args
spilled from -s and as -t accepts only valid values as 0,1 so any arg in
-s >1 or <0, gets in ksm_test failure

This went undetected since, before the addition of option -t, the next
case -M would immediately break out of the switch statement but that is no
longer the case

Add the missing break statement.

----Before----
./ksm_tests -H -s 100
Invalid merge type

----After----
./ksm_tests -H -s 100
Number of normal pages:    0
Number of huge pages:    50
Total size:    100 MiB
Total time:    0.401732682 s
Average speed:  248.922 MiB/s

Link: https://lkml.kernel.org/r/20230728163952.4634-1-ayush.jain3@amd.com
Fixes: 07115fcc15b4 ("selftests/mm: add new selftests for KSM")
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-ksm-fix-incorrect-evaluation-of-parameter
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -831,6 +831,7 @@ int main(int argc, char *argv[])
 				printf("Size must be greater than 0\n");
 				return KSFT_FAIL;
 			}
+			break;
 		case 't':
 			{
 				int tmp = atoi(optarg);
_

Patches currently in -mm which might be from ayush.jain3@amd.com are

selftests-mm-add-ksm_merge_time-tests.patch

