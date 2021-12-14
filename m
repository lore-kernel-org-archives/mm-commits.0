Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8412CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 18:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhLNS3M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:29:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhLNS3M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 13:29:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8A8B81C50
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 18:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF37C34604;
        Tue, 14 Dec 2021 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639506550;
        bh=eZ6tTaW4/uUtEWijG7RKLdNZ/eL/CDxGFzYxmH6R7AM=;
        h=Date:From:To:Subject:From;
        b=tjpvnNBrJY0U4/EYB3NPbYcP2BGA0pc6bIjnR8HLYBn7Iwqdi7iekd48Kx3X7d6Xb
         AiZA46lWggjjiqCdOwcnA84O5IprefpjHheMUbZBNm5P8aJlw/v/HCw3orn8hFH7Y2
         GAbLw++9VE3oB1E4PejSznObKVTgnPA4CWAh3uBY=
Date:   Tue, 14 Dec 2021 10:29:09 -0800
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, gpiccoli@igalia.com, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        siglesias@igalia.com, yzaikin@google.com
Subject:  +
 panic-allow-printing-extra-panic-information-on-kdump.patch added to -mm
 tree
Message-ID: <20211214182909._sQRtXv89%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: allow printing extra panic information on kdump
has been added to the -mm tree.  Its filename is
     panic-allow-printing-extra-panic-information-on-kdump.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-allow-printing-extra-panic-information-on-kdump.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-allow-printing-extra-panic-information-on-kdump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: panic: allow printing extra panic information on kdump

Currently we have the "panic_print" parameter/sysctl to allow some extra
information to be printed in a panic event.  On the other hand, the kdump
mechanism allows to kexec a new kernel to collect a memory dump for the
running kernel in case of panic.

Right now these options are incompatible: the user either sets the kdump
or makes use of "panic_print".  The code path of "panic_print" isn't
reached when kdump is configured.

There are situations though in which this would be interesting: for
example, in systems that are very memory constrained, a handcrafted tiny
kernel/initrd for kdump might be used in order to only collect the dmesg
in kdump kernel.  Even more common, systems with no disk space for the
full (compressed) memory dump might very well rely in this functionality
too, dumping only the dmesg with the additional information provided by
"panic_print".

So, this is what the patch does: allows both functionality to co-exist; if
"panic_print" is set and the system performs a kdump, the extra
information is printed on dmesg before the kexec.  Some notes about the
design choices here:

(a) We could have introduced a sysctl or an extra bit on "panic_print"
    to allow enabling the co-existence of kdump and "panic_print", but
    seems that would be over-engineering; we have 3 cases, let's check how
    this patch change things:

  - if the user have kdump set and not "panic_print", nothing changes;
  - if the user have "panic_print" set and not kdump, nothing changes;
  - if both are enabled, now we print the extra information before kdump,
    which is exactly the goal of the patch (and should be the goal of the
    user, since they enabled both options).

(b) We assume that the code path won't return from __crash_kexec() so
    we didn't guard against double execution of panic_print_sys_info().

Link: https://lkml.kernel.org/r/20211109202848.610874-4-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/panic.c~panic-allow-printing-extra-panic-information-on-kdump
+++ a/kernel/panic.c
@@ -245,6 +245,13 @@ void panic(const char *fmt, ...)
 	kgdb_panic(buf);
 
 	/*
+	 * If we have a kdump kernel loaded, give a chance to panic_print
+	 * show some extra information on kernel log if it was set...
+	 */
+	if (kexec_crash_loaded())
+		panic_print_sys_info();
+
+	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
 	 * If we want to run this after calling panic_notifiers, pass
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
panic-allow-printing-extra-panic-information-on-kdump.patch

