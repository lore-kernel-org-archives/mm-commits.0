Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C138BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 00:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiBVAf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 19:35:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiBVAf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 19:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD63C255B6
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 16:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 647C9B810F5
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 00:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AA6C340E9;
        Tue, 22 Feb 2022 00:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645490132;
        bh=T7Cf0W5+pOkdoEA8Rw8kh1X4RMjmKrP1XV3fY5Q8bLo=;
        h=Date:To:From:Subject:From;
        b=ipYeHhsOAqs498SKQX4KCOFwihatNcyAKm8iB6WfDzWalseX3WhDkUqr6UJS//WEa
         MNGdacs46semcTfrV8BgYx14G1jsvq+l0m/7V+/h62az/rMTBMlNtEdUFVpaLu3MgR
         3sC9CPWDyBXLBkFq6bPHA9mDEMHDQpGxuN/cHxNk=
Date:   Mon, 21 Feb 2022 16:35:31 -0800
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        siglesias@igalia.com, mcgrof@kernel.org, keescook@chromium.org,
        feng.tang@intel.com, dyoung@redhat.com, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-allow-printing-extra-panic-information-on-kdump.patch removed from -mm tree
Message-Id: <20220222003532.10AA6C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: allow printing extra panic information on kdump
has been removed from the -mm tree.  Its filename was
     panic-allow-printing-extra-panic-information-on-kdump.patch

This patch was dropped because an updated version will be merged

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
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/panic.c~panic-allow-printing-extra-panic-information-on-kdump
+++ a/kernel/panic.c
@@ -255,6 +255,13 @@ void panic(const char *fmt, ...)
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

