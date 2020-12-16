Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A6AC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1ECE23343
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgLPErf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPErf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:35 -0500
Date:   Tue, 15 Dec 2020 20:46:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094014;
        bh=VqtflUuq686Ii3cr+/0Jji4PRER3XJTpOgNWRYmeBaY=;
        h=From:To:Subject:In-Reply-To:From;
        b=WE6BNbwgoHrTaRPP7egXj6uBYU+FjZfF9TwcVe39R/Aca2+YkBLyO+9tTpY56gNaz
         Bqjbaj4PuIalAbzS14PeAhwuq0jKUxp9y6lJ3hT0+/nU0sGkhJfrdi7ew69N3+8IzH
         KUm4NJocqcN95NG26cbOr/NgQI2L3QJNQxTwE2aA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, fabf@skynet.be,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        linux-mm@kvack.org, linux@roeck-us.net, mcroce@microsoft.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pmladek@suse.com, robinmholt@gmail.com, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 83/95] reboot: refactor and comment the cpu
 selection code
Message-ID: <20201216044653.mATcBG6e3%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>
Subject: reboot: refactor and comment the cpu selection code

Small improvements to the code, without changing the way it works:
- use a local variable, to avoid a small time lapse where reboot_cpu
  can have an invalid value
- comment the code which is not easy to understand at a glance
- merge two identical code blocks into one
- replace pointer arithmetics with equivalent array syntax

Link: https://lkml.kernel.org/r/20201103214025.116799-4-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Robin Holt <robinmholt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/kernel/reboot.c~reboot-refactor-and-comment-the-cpu-selection-code
+++ a/kernel/reboot.c
@@ -553,20 +553,24 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 's':
-			if (isdigit(*(str+1)))
-				reboot_cpu = simple_strtoul(str+1, NULL, 0);
-			else if (str[1] == 'm' && str[2] == 'p' &&
-							isdigit(*(str+3)))
-				reboot_cpu = simple_strtoul(str+3, NULL, 0);
-			else
+			/*
+			 * reboot_cpu is s[mp]#### with #### being the processor
+			 * to be used for rebooting. Skip 's' or 'smp' prefix.
+			 */
+			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
+
+			if (isdigit(str[0])) {
+				int cpu = simple_strtoul(str, NULL, 0);
+
+				if (cpu >= num_possible_cpus()) {
+					pr_err("Ignoring the CPU number in reboot= option. "
+					"CPU %d exceeds possible cpu number %d\n",
+					cpu, num_possible_cpus());
+					break;
+				}
+				reboot_cpu = cpu;
+			} else
 				*mode = REBOOT_SOFT;
-			if (reboot_cpu >= num_possible_cpus()) {
-				pr_err("Ignoring the CPU number in reboot= option. "
-				       "CPU %d exceeds possible cpu number %d\n",
-				       reboot_cpu, num_possible_cpus());
-				reboot_cpu = 0;
-				break;
-			}
 			break;
 
 		case 'g':
_
