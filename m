Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD437CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjJRVoT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbjJRVoJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:44:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B02C120
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:44:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AACC433C8;
        Wed, 18 Oct 2023 21:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665441;
        bh=QxN0K5Vc/Yp8JJvoO+rQquWXfSp0Rguzlfr0oq5x5Yo=;
        h=Date:To:From:Subject:From;
        b=ZqqxvWQBfmsnMsJzT1sBfBvWqJYsuSulQJ18UJgEPkOj20nlZxAjdcBP2030MJU5w
         r79w8qJzySZf6uXpxEeab0muUiRK+gZie5g0/Zoc4QXpALoHBL6ycrqFig8ilH3mcK
         2HaQ/va4WKkTyWhwcfn3jZOtYDTv2rQ10SMWpXok=
Date:   Wed, 18 Oct 2023 14:44:00 -0700
To:     mm-commits@vger.kernel.org, ojeda@kernel.org, n.schier@avm.de,
        ndesaulniers@google.com, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, 2023002089@link.tyut.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-show_delta-add-__main__-judgement-before-main-code.patch removed from -mm tree
Message-Id: <20231018214401.55AACC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/show_delta: add __main__ judgement before main code
has been removed from the -mm tree.  Its filename was
     scripts-show_delta-add-__main__-judgement-before-main-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hu Haowen <2023002089@link.tyut.edu.cn>
Subject: scripts/show_delta: add __main__ judgement before main code
Date: Fri, 13 Oct 2023 21:28:32 +0800

When doing Python programming it is a nice convention to insert the if
statement `if __name__ == "__main__":` before any main code that does
actual functionalities to ensure the code will be executed only as a
script rather than as an imported module.  Hence attach the missing
judgement to show_delta.

Link: https://lkml.kernel.org/r/20231013132832.165768-1-2023002089@link.tyut.edu.cn
Signed-off-by: Hu Haowen <2023002089@link.tyut.edu.cn>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/show_delta |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/show_delta~scripts-show_delta-add-__main__-judgement-before-main-code
+++ a/scripts/show_delta
@@ -125,4 +125,5 @@ def main():
 	for line in lines:
 		print (convert_line(line, base_time),)
 
-main()
+if __name__ == "__main__":
+	main()
_

Patches currently in -mm which might be from 2023002089@link.tyut.edu.cn are


