Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25877C43219
	for <mm-commits@archiver.kernel.org>; Tue, 23 Nov 2021 22:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhKWWtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238741AbhKWWs6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 17:48:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC8A60FE3;
        Tue, 23 Nov 2021 22:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707549;
        bh=Co3j/HXxn3+o9LjnpVw8n96BQlG+HTJhbzO8U2cbt14=;
        h=Date:From:To:Subject:From;
        b=Qu07udVXmaVL7gSF/lMt6CoUjdiyamlVBF9kAMyaXntmK25w4iNOJ8N7aLxebrxu8
         BysK+lmbORrQhLUfFmpvTGssUJqc0QN0HvXO8fla2welO0CJCJSU0VL9SgidAXusXF
         IU9H1fwuBAEUR5ZOpxaYKLVwjHbJ5bX2DRg1rXdw=
Date:   Tue, 23 Nov 2021 14:45:49 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com
Subject:  [merged] hexagon-ignore-vmlinuxlds.patch removed from -mm
 tree
Message-ID: <20211123224549.Sycm-D-Wh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: ignore vmlinux.lds
has been removed from the -mm tree.  Its filename was
     hexagon-ignore-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: ignore vmlinux.lds

After building allmodconfig, there is an untracked vmlinux.lds file in
arch/hexagon/kernel:

$ git ls-files . --exclude-standard --others
arch/hexagon/kernel/vmlinux.lds

Ignore it as all other architectures have.

Link: https://lkml.kernel.org/r/20211115174250.1994179-4-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- /dev/null
+++ a/arch/hexagon/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
_

Patches currently in -mm which might be from nathan@kernel.org are


