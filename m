Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15028C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCC061108
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhIXC1a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243813AbhIXC12 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 22:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AE16103D;
        Fri, 24 Sep 2021 02:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632450355;
        bh=3+ww7Vuai5imCrqk8bnpDtnKde6efx5K5/ZHtW7hCl8=;
        h=Date:From:To:Subject:From;
        b=duw08OVTNXSGPaMHymgs1zMBuAe17E8HYBi9VEObwwsFrk2WXNAhlUeChJIdyh/i7
         1O0+gyzkbu3EaymPmSDBpPoeI3vlV9DVyKJ5vuHZXXro12af3yjazY7yqAJDJRX052
         znHV9hADuFMQ6TCZyLCZg5XSxmb5LvlpPr/XPPRM=
Date:   Thu, 23 Sep 2021 19:25:55 -0700
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, joe@perches.com, lgirdwood@gmail.com,
        mm-commits@vger.kernel.org, perex@perex.cz,
        rikard.falkeborn@gmail.com, tiwai@suse.com
Subject:  +
 const_structscheckpatch-add-a-few-sound-ops-structs.patch added to -mm tree
Message-ID: <20210924022555.2kKFVFV3_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add a few sound ops structs
has been added to the -mm tree.  Its filename is
     const_structscheckpatch-add-a-few-sound-ops-structs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/const_structscheckpatch-add-a-few-sound-ops-structs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/const_structscheckpatch-add-a-few-sound-ops-structs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add a few sound ops structs

Add a couple of commonly used (>50 instances) sound ops structs that are
typically const.

Link: https://lkml.kernel.org/r/20210922211042.38017-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-a-few-sound-ops-structs
+++ a/scripts/const_structs.checkpatch
@@ -54,7 +54,11 @@ sd_desc
 seq_operations
 sirfsoc_padmux
 snd_ac97_build_ops
+snd_pcm_ops
+snd_rawmidi_ops
 snd_soc_component_driver
+snd_soc_dai_ops
+snd_soc_ops
 soc_pcmcia_socket_ops
 stacktrace_ops
 sysfs_ops
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

const_structscheckpatch-add-a-few-sound-ops-structs.patch

