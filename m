Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B03CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjJNWVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjJNWVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E09C9
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:21:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B433C433C7;
        Sat, 14 Oct 2023 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697322077;
        bh=YKF9/VWD5ozbMerFuz1VUXK0EncEVgbMWlImwEKaEoE=;
        h=Date:To:From:Subject:From;
        b=C9d2DkZJ4e9c858A6Y/f+QFAqBOdUqeXhCkhJgwe3GYkRyNUiLEZw6Xn+lu2IOF0+
         XiEtjY0o6uBXikztzMcq2l0+8oMwgmo1CP4PkANidTebs6sO/1EX6tlEBtLf4ZF8dC
         RStyp6I83Aw029LASbBHtgLPftf7Yu5e/qxhtymc=
Date:   Sat, 14 Oct 2023 15:21:06 -0700
To:     mm-commits@vger.kernel.org, ojeda@kernel.org, n.schier@avm.de,
        ndesaulniers@google.com, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, 2023002089@link.tyut.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-show_delta-add-__main__-judgement-before-main-code.patch added to mm-nonmm-unstable branch
Message-Id: <20231014222117.5B433C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/show_delta: add __main__ judgement before main code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-show_delta-add-__main__-judgement-before-main-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-show_delta-add-__main__-judgement-before-main-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

scripts-show_delta-add-__main__-judgement-before-main-code.patch

