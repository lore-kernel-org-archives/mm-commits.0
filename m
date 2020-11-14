Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CC1C63699
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C4922227F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGs1Q5ED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKNGwE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGwE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:52:04 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313B922282;
        Sat, 14 Nov 2020 06:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336723;
        bh=KOEu7SPo3dHDOVfsJrzFpcbuRAiGkAnaqEgRozzrBSg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pGs1Q5EDDXY+6CXUasClnK9pSqkMcTimVvM6lGOrZ4NjJm1XxBA1z/3lbAdzosl0P
         cWZYEwHqupMu7JZkG5T41aFZm2O4AwZEtPqpPEd+jRYxWP14+YFXRuFpLrYF8ZguJ6
         9CRdsPjLlW9yMmWEQLwVlUM7gNHWuzBNjEwfqKUY=
Date:   Fri, 13 Nov 2020 22:52:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, fabf@skynet.be,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        linux-mm@kvack.org, linux@roeck-us.net, mcroce@microsoft.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pmladek@suse.com, robinmholt@gmail.com, rppt@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 08/14] Revert "kernel/reboot.c: convert
 simple_strtoul to kstrtoint"
Message-ID: <20201114065202.FWrl0Eulf%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>
Subject: Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Patch series "fix parsing of reboot= cmdline", v3.

The parsing of the reboot= cmdline has two major errors:

- a missing bound check can crash the system on reboot
- parsing of the cpu number only works if specified last

Fix both.


This patch (of 2):

This reverts commit 616feab753972b97.

kstrtoint() and simple_strtoul() have a subtle difference which makes them
non interchangeable: if a non digit character is found amid the parsing,
the former will return an error, while the latter will just stop parsing,
e.g.  simple_strtoul("123xyx") = 123.

The kernel cmdline reboot= argument allows to specify the CPU used for
rebooting, with the syntax `s####` among the other flags, e.g. 
"reboot=warm,s31,force", so if this flag is not the last given, it's
silently ignored as well as the subsequent ones.

Link: https://lkml.kernel.org/r/20201103214025.116799-2-mcroce@linux.microsoft.com
Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/kernel/reboot.c~revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint
+++ a/kernel/reboot.c
@@ -551,22 +551,15 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 's':
-		{
-			int rc;
-
-			if (isdigit(*(str+1))) {
-				rc = kstrtoint(str+1, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else if (str[1] == 'm' && str[2] == 'p' &&
-				   isdigit(*(str+3))) {
-				rc = kstrtoint(str+3, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else
+			if (isdigit(*(str+1)))
+				reboot_cpu = simple_strtoul(str+1, NULL, 0);
+			else if (str[1] == 'm' && str[2] == 'p' &&
+							isdigit(*(str+3)))
+				reboot_cpu = simple_strtoul(str+3, NULL, 0);
+			else
 				*mode = REBOOT_SOFT;
 			break;
-		}
+
 		case 'g':
 			*mode = REBOOT_GPIO;
 			break;
_
