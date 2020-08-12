Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A691C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D8120658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196183;
	bh=8+7bHb/Ors1rycfH9WEQrlC5SDs+nT19hFIT/ByBNzw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JImHbThHXf0z7DbzuU8UoSSCBJk+CsB/WwjPc9miA3xIUwzYNkaADhQ3aMDYoqVLn
	 LwxYzo1Y8ykDlMfdJEiUC6gTwSUXWR1GeaXWz1+yX5DRg8YHZI9VadE8baAye0aiop
	 6trSCq0XAri1i0/fiLp9cZeXnH5Vv0HGapYDac8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 681FC20658;
        Wed, 12 Aug 2020 01:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196180;
        bh=8+7bHb/Ors1rycfH9WEQrlC5SDs+nT19hFIT/ByBNzw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k7Qav+a+B4Q35QuKW/PqI0GUOKksKjt2lA5xwgnTn/Ns5APsXWsHMCzx7PuY76fT1
         RrHpkNXlOrX/vwqCHvuEeztr/xWqGLcKSpSw5cmhyicvXhembLvnmQRP2tkFqCngFh
         CTffuzPrp6cOCs6caInvgr6ai4ylGpeKm4J0uBSo=
Date:   Tue, 11 Aug 2020 18:36:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ytht.net@gmail.com
Subject:  [patch 115/165] coredump: add %f for executable filename
Message-ID: <20200812013620.UOn7owBkI%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lepton Wu <ytht.net@gmail.com>
Subject: coredump: add %f for executable filename

The document reads "%e" should be "executable filename" while actually it
could be changed by things like pr_ctl PR_SET_NAME.  People who uses "%e"
in core_pattern get surprised when they find out they get thread name
instead of executable filename.

This is either a bug of document or a bug of code.  Since the behavior of
"%e" is there for long time, it could bring another surprise for users if
we "fix" the code.

So we just "fix" the document.  And more, for users who really need the
"executable filename" in core_pattern, we introduce a new "%f" for the
real executable filename.  We already have "%E" for executable path in
kernel, so just reuse most of its code for the new added "%f" format.

Link: http://lkml.kernel.org/r/20200701031432.2978761-1-ytht.net@gmail.com
Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    3 ++-
 fs/coredump.c                               |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~coredump-add-%f-for-executable-filename
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -164,7 +164,8 @@ core_pattern
 	%s		signal number
 	%t		UNIX time of dump
 	%h		hostname
-	%e		executable filename (may be shortened)
+	%e		executable filename (may be shortened, could be changed by prctl etc)
+	%f      	executable filename
 	%E		executable path
 	%c		maximum size of core file by resource limit RLIMIT_CORE
 	%<OTHER>	both are dropped
--- a/fs/coredump.c~coredump-add-%f-for-executable-filename
+++ a/fs/coredump.c
@@ -153,10 +153,10 @@ int cn_esc_printf(struct core_name *cn,
 	return ret;
 }
 
-static int cn_print_exe_file(struct core_name *cn)
+static int cn_print_exe_file(struct core_name *cn, bool name_only)
 {
 	struct file *exe_file;
-	char *pathbuf, *path;
+	char *pathbuf, *path, *ptr;
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
@@ -175,6 +175,11 @@ static int cn_print_exe_file(struct core
 		goto free_buf;
 	}
 
+	if (name_only) {
+		ptr = strrchr(path, '/');
+		if (ptr)
+			path = ptr + 1;
+	}
 	ret = cn_esc_printf(cn, "%s", path);
 
 free_buf:
@@ -301,12 +306,16 @@ static int format_corename(struct core_n
 					      utsname()->nodename);
 				up_read(&uts_sem);
 				break;
-			/* executable */
+			/* executable, could be changed by prctl PR_SET_NAME etc */
 			case 'e':
 				err = cn_esc_printf(cn, "%s", current->comm);
 				break;
+			/* file name of executable */
+			case 'f':
+				err = cn_print_exe_file(cn, true);
+				break;
 			case 'E':
-				err = cn_print_exe_file(cn);
+				err = cn_print_exe_file(cn, false);
 				break;
 			/* core limit size */
 			case 'c':
_
