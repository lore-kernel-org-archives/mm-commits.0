Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E59C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2B761207
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhKICgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235932AbhKICgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B5CD61208;
        Tue,  9 Nov 2021 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425208;
        bh=wHpXk4kUeyj17HE47oG7nwHoXUyNIqzK/jw67qyqJyo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wOE3iOVmvYTIGkX39NaYEqu9CTuDKSPHK4q8g8ehfJ6uDFnYhqgK3uVB2OHj2ZSeg
         ut5ef00I/wIgqOcP5sl1agMVwhIzljTkTqyT9K5Jl4RABmNZDZccZiNwFhGD6l1gbn
         8NvAKGjciM6+CZTagiWDrtq1L5n7kV7Pgc2RqhhY=
Date:   Mon, 08 Nov 2021 18:33:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, broonie@kernel.org, joe@perches.com,
        lgirdwood@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, perex@perex.cz,
        rikard.falkeborn@gmail.com, tiwai@suse.com,
        torvalds@linux-foundation.org
Subject:  [patch 39/87] const_structs.checkpatch: add a few sound
 ops structs
Message-ID: <20211109023328.SBppmfyB1%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
