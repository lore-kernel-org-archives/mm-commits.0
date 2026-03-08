Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE1293C42
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773005172; cv=none; b=GQeaElSff479pJguAXIZiUT7Z2HTbDCzEx/qCEbXZsUykugAWEjVKzoBVPk2HH3E9dn8yHfUSSw/v1/7fJ4y3zi+HT4ywka8X88BvmUxLMY7UkDSz1T3BYiY6KazPqkC6iZsJSV71o+Yn5zw3CsRXxA60wOZFf7ACwFQsPbx+g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773005172; c=relaxed/simple;
	bh=rM9LJ3U6xVrPuHjiRpcwxYNb2x95b5CAVgimMjCIvoI=;
	h=Date:To:From:Subject:Message-Id; b=f7zphott8Pl1Jmfs4gBzuLdo25JW81QM1IgH7bytPBNyNrz1GqsnEAWxQd4SS83hEMkEIPQSJvY2O+7+hcAbCQYRu7jgdNgKDJJbnu2n6Wxv68waHq9Rr837kJ+a7Bg72WK3AiqtK7sAW34JCzp+I0CRI2DUtef4ao/Thx9DaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yJjhym2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJjhym2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF176C116C6;
	Sun,  8 Mar 2026 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773005171;
	bh=rM9LJ3U6xVrPuHjiRpcwxYNb2x95b5CAVgimMjCIvoI=;
	h=Date:To:From:Subject:From;
	b=yJjhym2GbXgVe+NeQirPgZZg4XuAVDdUlJoLuCE2QGUSusBEic4mTNd+PBYQDWiOh
	 naBb93ce6DcliMXxWGgtX5sovGnNzG+W7krQY0LlmhiauXfEykzl7UyxeBEzQOqo63
	 rSQpVONsG9ZrzbxvjvNtGBhmbGVA36o+abSZLpS8=
Date: Sun, 08 Mar 2026 14:26:11 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,lkp@intel.com,jiang.kun2@zte.com.cn,bsingharora@gmail.com,arnd@arndb.de,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch added to mm-nonmm-unstable branch
Message-Id: <20260308212611.AF176C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/getdelays: use the static UAPI headers from tools/include/uapi
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: tools/getdelays: use the static UAPI headers from tools/include/uapi
Date: Sat, 07 Mar 2026 09:47:53 +0100

The include directory ../../usr/include is only present if an in-tree
kernel build with CONFIG_HEADERS_INSTALL was done before.
Otherwise the system UAPI headers are used, which most likely are not
the most recent ones.

To make sure to always have access to up-to-date UAPI headers,
use the static copy in tools/include/uapi.

Link: https://lkml.kernel.org/r/20260307-accounting-taskstats-h-v1-2-0b75915c6ce5@weissschuh.net
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202603062103.Z5fecwZD-lkp@intel.com/
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/Makefile~tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi
+++ a/tools/accounting/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CC := $(CROSS_COMPILE)gcc
-CFLAGS := -I../../usr/include
+CFLAGS := -I../include/uapi/
 
 PROGS := getdelays procacct delaytop
 
_

Patches currently in -mm which might be from linux@weissschuh.net are

tools-headers-uapi-sync-linux-taskstatsh.patch
tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch

