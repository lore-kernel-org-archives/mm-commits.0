Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A417493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMKAmXEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFADC433C8;
	Mon, 11 Dec 2023 01:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257798;
	bh=KxJsI5WAk7TT7FoP56QBT00vSWr+a2NqLKzzq4I3XP0=;
	h=Date:To:From:Subject:From;
	b=HMKAmXEMB0eWZlBFd52MQEIuq9pxmU+13aKf8R0WjV2Jvz66w/xtP3bblt2KiwlJN
	 EREnOt1GrpTOgoCle2gK2aYJK/ouKsYBOTsoyglxGMdOgUJW3bCEIxrn6b5ej9yn3L
	 tekcqNB+kzKO/KwPseJfCPNbgLiPJogyb0ZCZlnE=
Date: Sun, 10 Dec 2023 17:23:18 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-time-mark-time_init_deferred-as-static.patch removed from -mm tree
Message-Id: <20231211012318.ACFADC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: time: mark time_init_deferred() as static
has been removed from the -mm tree.  Its filename was
     hexagon-time-mark-time_init_deferred-as-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: time: mark time_init_deferred() as static
Date: Thu, 30 Nov 2023 15:58:22 -0700

Clang warns:

  arch/hexagon/kernel/time.c:163:13: warning: no previous prototype for function 'time_init_deferred' [-Wmissing-prototypes]
    163 | void __init time_init_deferred(void)
        |             ^
  arch/hexagon/kernel/time.c:163:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    163 | void __init time_init_deferred(void)
        | ^
        | static

This function is not used outside of this translation unit so mark it as
static to resolve the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-9-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/kernel/time.c~hexagon-time-mark-time_init_deferred-as-static
+++ a/arch/hexagon/kernel/time.c
@@ -161,7 +161,7 @@ static irqreturn_t timer_interrupt(int i
  * This runs just before the delay loop is calibrated, and
  * is used for delay calibration.
  */
-void __init time_init_deferred(void)
+static void __init time_init_deferred(void)
 {
 	struct resource *resource = NULL;
 	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

