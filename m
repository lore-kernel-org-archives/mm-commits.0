Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1102C433E7
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C86120795
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602397042;
	bh=vSVMQN1k1tAhl7tKsWeYYHcp4ZulzxyeG/+TSkI88Hk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=M7x9KOaXWonap4kE5P+duSCOXxaZo7EOw+zVBClpAm5a7FdcAbj14/hlBks1OWasa
	 Z5jfD66uT+bmCbwiCiaxS26QQZPnrv0N+A6/eM2YnrVsrCltdBEFwX2piCSvCs2oHh
	 +Zie7C7CyplZosHyxqezJ1cfPXfI+sPv2VZrif5U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgJKGQ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Oct 2020 02:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgJKGQ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Oct 2020 02:16:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192D420795;
        Sun, 11 Oct 2020 06:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602396988;
        bh=vSVMQN1k1tAhl7tKsWeYYHcp4ZulzxyeG/+TSkI88Hk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wi0i8oybuYbbLC7hubNnmHnSBgrqE6findsYCnKElUA1xnWQ1Gx7oBcBsu3WjC/ji
         nDkmm2HP2CBwxe8D4g2S681HALfyo0nYtaoRVzpL0u1C7VxcqkC4DJ3elilmApApZ3
         yA+YsJzPW7Ask2PAuYJ/SjCFbfHNF8oKUxK6dWpc=
Date:   Sat, 10 Oct 2020 23:16:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, keescook@chromium.org,
        linux-mm@kvack.org, me@tobin.cc, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, re.emese@gmail.com,
        torvalds@linux-foundation.org, tycho@tycho.pizza
Subject:  [patch 1/5] MAINTAINERS: change hardening mailing list
Message-ID: <20201011061627.2KW0I-WjV%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Kees Cook <keescook@chromium.org>
Subject: MAINTAINERS: change hardening mailing list

As more email from git history gets aimed at the OpenWall
kernel-hardening@ list, there has been a desire to separate "new topics"
from "on-going" work.  To handle this, the superset of hardening email
topics are now to be directed to linux-hardening@vger.kernel.org.  Update
the MAINTAINERS file and the .mailmap to accomplish this, so that
linux-hardening@ can be treated like any other regular upstream kernel
development list.

Link: https://lore.kernel.org/linux-hardening/202010051443.279CC265D@keesco=
ok/
Link: https://lkml.kernel.org/r/20201006000012.2768958-1-keescook@chromium.=
org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>
Cc: Tycho Andersen <tycho@tycho.pizza>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-change-hardening-mailing-list
+++ a/.mailmap
@@ -188,6 +188,7 @@ Leon Romanovsky <leon@kernel.org> <leonr
 Linas Vepstas <linas@austin.ibm.com>
 Linus L=C3=BCssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus L=C3=BCssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
+<linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
--- a/MAINTAINERS~maintainers-change-hardening-mailing-list
+++ a/MAINTAINERS
@@ -7240,7 +7240,7 @@ F:	drivers/staging/gasket/
 GCC PLUGINS
 M:	Kees Cook <keescook@chromium.org>
 R:	Emese Revfy <re.emese@gmail.com>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/gcc-plugins.rst
 F:	scripts/Makefile.gcc-plugins
@@ -9802,7 +9802,7 @@ F:	drivers/scsi/53c700*
 LEAKING_ADDRESSES
 M:	Tobin C. Harding <me@tobin.cc>
 M:	Tycho Andersen <tycho@tycho.pizza>
-L:	kernel-hardening@lists.openwall.com
+L:	linux-hardening@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
 F:	scripts/leaking_addresses.pl
_
