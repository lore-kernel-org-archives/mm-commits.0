Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DD3C64E7B
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE27620674
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:09:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ljWqAebG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgK3VJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgK3VJ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 16:09:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CDBF2073C;
        Mon, 30 Nov 2020 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606770519;
        bh=6Yx678sMLDZSAuFc0inpbfSAJY2oYqY3sU3rSpenolE=;
        h=Date:From:To:Subject:From;
        b=ljWqAebGFNubiQRNwCpW6eV/vVkWYwPNP+aaC5fJ5T0li4v1wP/Z2KqOAHv0E6zzK
         eN4OfduBKaG3JToXIbeC6WjIlTePGErQNU1iq8lVmXtAPKs+tV4JQQtObr40KMx9GC
         mflMpN1W1bTcdmU0YLyD3jsDXUseWsu4dsHFs2jg=
Date:   Mon, 30 Nov 2020 13:08:38 -0800
From:   akpm@linux-foundation.org
To:     mcroce@microsoft.com, mm-commits@vger.kernel.org, pmladek@suse.com
Subject:  +
 reboot-allow-to-override-reboot-type-if-quirks-are-found.patch added to -mm
 tree
Message-ID: <20201130210838.ovq9OTg1k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: allow to override reboot type if quirks are found
has been added to the -mm tree.  Its filename is
     reboot-allow-to-override-reboot-type-if-quirks-are-found.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reboot-allow-to-override-reboot-type-if-quirks-are-found.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reboot-allow-to-override-reboot-type-if-quirks-are-found.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: reboot: allow to override reboot type if quirks are found

Patch series "reboot: sysfs improvements".

Some improvements to the sysfs reboot interface: hide not working settings
and support machines with known reboot quirks.


This patch (of 2):

On some machines a quirk can force a specific reboot type.  Quirks are
found during a DMI scan, the list of machines which need special reboot
handling is defined in reboot_dmi_table.

The kernel command line reboot= option overrides this via a global
variable `reboot_default`, so that the reboot type requested in the
command line is really performed.

This was not true when setting the reboot type via the new sysfs
interface.  Fix this by setting reboot_default upon the first change, like
reboot_setup() does for the command line.

Link: https://lkml.kernel.org/r/20201130173717.198952-1-mcroce@linux.microsoft.com
Link: https://lkml.kernel.org/r/20201130173717.198952-2-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/reboot.c~reboot-allow-to-override-reboot-type-if-quirks-are-found
+++ a/kernel/reboot.c
@@ -660,6 +660,8 @@ static ssize_t mode_store(struct kobject
 	else
 		return -EINVAL;
 
+	reboot_default = 0;
+
 	return count;
 }
 static struct kobj_attribute reboot_mode_attr = __ATTR_RW(mode);
@@ -714,6 +716,8 @@ static ssize_t type_store(struct kobject
 	else
 		return -EINVAL;
 
+	reboot_default = 0;
+
 	return count;
 }
 static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
@@ -739,6 +743,7 @@ static ssize_t cpu_store(struct kobject
 	if (cpunum >= num_possible_cpus())
 		return -ERANGE;
 
+	reboot_default = 0;
 	reboot_cpu = cpunum;
 
 	return count;
@@ -760,6 +765,7 @@ static ssize_t force_store(struct kobjec
 	if (kstrtobool(buf, &res))
 		return -EINVAL;
 
+	reboot_default = 0;
 	reboot_force = res;
 
 	return count;
_

Patches currently in -mm which might be from mcroce@microsoft.com are

reboot-refactor-and-comment-the-cpu-selection-code.patch
reboot-allow-to-specify-reboot-mode-via-sysfs.patch
reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch
reboot-allow-to-override-reboot-type-if-quirks-are-found.patch
reboot-hide-from-sysfs-not-applicable-settings.patch

