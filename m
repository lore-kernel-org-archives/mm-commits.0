Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B89FE9412F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjJFVrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbjJFVrh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7021F7
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB13C433C9;
        Fri,  6 Oct 2023 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628855;
        bh=TbfHb6eGIyUKsp5J1aJmmZkyrWBFRfxYgHEOPTW9w18=;
        h=Date:To:From:Subject:From;
        b=naSVtiCm0arz3VhcIecSefNGD/bTyW7cAV5KaFdR+/gR7F+wXjWE95Q9aJoPnDWi/
         KRMLDbLWHkZCq/wnlpZh5pF+OYQmCh0kowh+BWFeINGoQcVoumCO0KThgJZ1QN3xUZ
         RMTTKwY50R+ee3TCnNWwCmeQ0Kl1n2Py3qPFN7/Y=
Date:   Fri, 06 Oct 2023 14:47:32 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch removed from -mm tree
Message-Id: <20231006214735.2AB13C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftest: vm: fix tabs/spaces inconsistency in the mdwe test
has been removed from the -mm tree.  Its filename was
     kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florent Revest <revest@chromium.org>
Subject: kselftest: vm: fix tabs/spaces inconsistency in the mdwe test
Date: Mon, 28 Aug 2023 17:08:53 +0200

Patch series "MDWE without inheritance", v4.

Joey recently introduced a Memory-Deny-Write-Executable (MDWE) prctl which
tags current with a flag that prevents pages that were previously not
executable from becoming executable.  This tag always gets inherited by
children tasks.  (it's in MMF_INIT_MASK)

At Google, we've been using a somewhat similar downstream patch for a few
years now.  To make the adoption of this feature easier, we've had it
support a mode in which the W^X flag does not propagate to children.  For
example, this is handy if a C process which wants W^X protection suspects
it could start children processes that would use a JIT.

I'd like to align our features with the upstream prctl.  This series
proposes a new NO_INHERIT flag to the MDWE prctl to make this kind of
adoption easier.  It sets a different flag in current that is not in
MMF_INIT_MASK and which does not propagate.

As part of looking into MDWE, I also fixed a couple of things in the MDWE
test.

The background for this was discussed in these threads:
v1: https://lore.kernel.org/all/66900d0ad42797a55259061f757beece@ispras.ru/
v2: https://lore.kernel.org/all/d7e3749c-a718-df94-92af-1cb0fecab772@redhat.com/


This patch (of 6):

Fix tabs/spaces inconsistency in the mdwe test.

Link: https://lkml.kernel.org/r/20230828150858.393570-1-revest@chromium.org
Link: https://lkml.kernel.org/r/20230828150858.393570-2-revest@chromium.org
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -49,19 +49,19 @@ FIXTURE_VARIANT(mdwe)
 
 FIXTURE_VARIANT_ADD(mdwe, stock)
 {
-        .enabled = false,
+	.enabled = false,
 	.forked = false,
 };
 
 FIXTURE_VARIANT_ADD(mdwe, enabled)
 {
-        .enabled = true,
+	.enabled = true,
 	.forked = false,
 };
 
 FIXTURE_VARIANT_ADD(mdwe, forked)
 {
-        .enabled = true,
+	.enabled = true,
 	.forked = true,
 };
 
_

Patches currently in -mm which might be from revest@chromium.org are


