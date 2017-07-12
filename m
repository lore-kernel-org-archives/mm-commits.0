From: akpm@linux-foundation.org
Subject: + test_sysctl-add-generic-script-to-expand-on-tests.patch added
 to -mm tree
Date: Wed, 12 Jul 2017 12:40:43 -0700
Message-ID: <59667b3b.NrjeuxE5IJsH1oUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGLTko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 15:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, keescook@chromium.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_sysctl: add generic script to expand on tests
has been added to the -mm tree.  Its filename is
     test_sysctl-add-generic-script-to-expand-on-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_sysctl-add-generic-script-to-expand-on-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_sysctl-add-generic-script-to-expand-on-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Return-Path: <lurodriguez@suse.de>
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on y
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS autolearn=unavailable autolearn_force=no
	version=3.4.1
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by localhost.localdomain (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id v6CD6lDi020865
	for <akpm@localhost>; Wed, 12 Jul 2017 06:06:48 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost.localdomain with IMAP (fetchmail-6.3.26)
	for <akpm@localhost> (single-drop); Wed, 12 Jul 2017 06:06:48 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id 32EF48FF
	for <akpm@mail.linuxfoundation.org>; Wed, 12 Jul 2017 13:06:15 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wr0-f198.google.com (mail-wr0-f198.google.com [209.85.128.198])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 755A319B
	for <akpm@mail.linuxfoundation.org>; Wed, 12 Jul 2017 13:06:13 +0000 (UTC)
Received: by mail-wr0-f198.google.com with SMTP id p64so5444789wrc.8
        for <akpm@mail.linuxfoundation.org>; Wed, 12 Jul 2017 06:06:13 -0700 (PDT)
ARC-Seal: i=3; a=rsa-sha256; t=1499864772; cv=pass;
        d=google.com; s=arc-20160816;
        b=JskqUrEAM580qqQnSMf96caVV+cqTDx2zQ6iyY2AAQ9zagzPnhl7e8lg5FeSEBzEwC
         DMQGBla85TRPS2KDsp8VG0Z0hilO7WKSJbTMie0BrPGEAipSFpWmELF5TGw+PQVW+gzJ
         DnOJzXCvCnCSMvtnx3u9R/5uEtsWvtxx44sDy2ZC1mrCB4hYgjRvTDZqT3oyo5APZuB+
         U5Da71oOz09RNjc7xDHbIYNRak2vuJ5M6DjinuMtjkxnN1UdFK1iP0g3lNSPEfPbIJLP
         R9A4SXD0yzKBUIigASU8G+pjCeLBLN9VnRLtG0ExUvrK30mFhtJc50FrgM3TnlXRVvuz
         vZfA==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=delivered-to:references:in-reply-to:message-id:date:subject:cc:to
         :from:dmarc-filter:delivered-to:arc-authentication-results
         :arc-message-signature:delivered-to:delivered-to:resent-to
         :resent-message-id:resent-date:resent-from
         :arc-authentication-results:arc-message-signature
         :arc-authentication-results;
        bh=S0/Fq0DIIZuKl0bNTOWv5hOReTEtHYRCCt6H3Mx8JI4=;
        b=MZjFnp5spaUoUk+rZi9s6zB3QVRBOFieXhy2Dg1/FH2sEkUrTQHDTVbc5C4SeocmTG
         wKXjzgB/a9KkpUEjGfYhpVAyL8TvUK5BqunhKlHgKjPce4VG9T7fJnsTGKRiIOSstV8F
         WYvgbA55izFCiNfWV2VqgaUZLJjmL6zyZXEwI6KuJnvx/Uero7GnZrQNAvFSpT3iM5+d
         7dC43I2X3azW4WCnEFEf+EmtsyyIB7tiZE+MkHVnL1VPWRPq6JypKFw1WQuEek3+thLP
         zkRi1IrtBRitjKlSCGM6dUcfUsFs08ei2ZQ/RnDn/8n54lu8bwHW27wWhCt0Wez5Qk3z
         1ilA==
ARC-Authentication-Results: i=3; mx.google.com;
       arc=pass (i=1 spf=pass spfdomain=kernel.org);
       spf=pass (google.com: domain of lurodriguez@suse.de designates 195.135.220.15 as permitted sender) smtp.mailfrom=lurodriguez@suse.de
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:resent-from:resent-date:resent-message-id
         :resent-to:delivered-to:x-original-authentication-results
         :delivered-to:delivered-to:dmarc-filter:from:to:cc:subject:date
         :message-id:in-reply-to:references:delivered-to;
        bh=S0/Fq0DIIZuKl0bNTOWv5hOReTEtHYRCCt6H3Mx8JI4=;
        b=l+u0heSxAb8ls2Q4YeqDV0FUCxah3Cpf6LgOFvH/w9FTpT2OrhA37jkMKmjVegrXK1
         Lm2/4dgIg2zle3Gx3d2GMJxNBfrhUn90siA49oNOf4jJfoSLAkfxlk8FaDVPLfEYovuC
         12RRPu8s+9alqC1pyVCQrlaC0gwkEAh/ZO4zmGNPZVSHfFKPnyEyRNDjzjc/3aAC4ROv
         V9oZlIYktSLpe7BQ+bPzXf/kn8BEcSD8NIRHKdIlJVCeUpLD8mWyiRn/VcM0v594zyeG
         UPVyzzq4AVr/47WgFBwHJ4Eyb3+utZOx0dXXngJfHCAPcerfjh4ITLyyOFiYTt7R/bvj
         gQlg==
X-Gm-Message-State: AIVw113nJyBGUar7T97xuG2e1n3cIgqdA8Mxvvd6ZbIQutYtJOAGTLgb
	r71Vdz9sDw7G1KqbnJBlrclr5PymUbGcSNLdEM+DLXHyPwm+6x2l0DJlz8lgdqx8ESE+kisjET3
	cin5BmKlAcySjCcOm9VsFG+7CS93mTpl79F9Em/kTyAFOxW/b5yqH2TMtOgNgoLhiJd2A3rQlX8
	fDm1/flaCMOSCWKEMIKW09v/hZ0g2JA8nsz2AxwZVjWh0s17mVrHkFVqODPPxtPZ4fGtuuxxP78
	gyDGbNEDabmi5twJPuUeOFvxkrDDlL7/Y6/cE0Hk/e62hXNxeJolw/QwtgANYEsPVHSyIcfi10G
	NACsW/DDl9auTsehMbdrpysKedrxW+GCz6aEaglxbhW020NtHKH1vR8XTywlCyte7VAzmFSC1Xx
	ptBv5qCEn6DPrPo5W8Nle8Sl2
X-Received: by 10.28.65.135 with SMTP id o129mr2664464wma.20.1499864772143;
        Wed, 12 Jul 2017 06:06:12 -0700 (PDT)
X-Received: by 10.28.65.135 with SMTP id o129mr2664405wma.20.1499864771133;
        Wed, 12 Jul 2017 06:06:11 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; t=1499864771; cv=pass;
        d=google.com; s=arc-20160816;
        b=Q6qqJdlRX5ofu/McMrOydzUoHvtVEtBeSk/ST61D5C5VZotX+vRyZbMRIk5pk06utf
         Q0LzEmVK2C33AJfwu+LMvU8LpMr8L+ur2hBUkyXQxuYKUum4LnFWBykNhg8CBu3R+jpy
         6qALbL/uYlVp8zemU4OYzfAAbm1pe8qfFHGo+q9/uMcq6hdWz9pyuPi520HXmpQSIxMS
         U0GGbtRRCMyZWVt1SyDeocvEwX4Zb5Kzf7LBDKXz+lkAVSoRUCJ4il+h+yGewPNUh0jC
         pzgEHrGbKNtyGWxTZ5dDOm2HM3kOHmlAnnkAB3DZS2gnLXZZGNFltYW1RpLhRI6yNFhF
         vfig==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dmarc-filter:delivered-to:arc-authentication-results
         :arc-message-signature:delivered-to:delivered-to:resent-to
         :resent-message-id:resent-date:resent-from
         :arc-authentication-results;
        bh=S0/Fq0DIIZuKl0bNTOWv5hOReTEtHYRCCt6H3Mx8JI4=;
        b=H9rnnNN8eaw4IOhdYaZ30bW9rrXRFgQnYsRTF9bOGxWfA5RwjvSmrP8ZqiQm05oyW8
         wakr7vBCyLsREqdkzVkYK2WffEz7WzDrPP7HBZEW7R9e/ffK8VwfhpXcnveaVRJCyjj/
         DFFPQVNzKji7/RUJWe/RH1pxFnvjqwBnoLk/is8c3TZ9DqgQ3Kki/aWr8jzoXuebjHDE
         VFBNdvpXCYKw5A4QjzXRivzhT+qnCD27n+yQqXom1d1F6UCVPlhLJ4owg1SY14cm+Tvk
         pTy8n9gXVFPSXIXLZfqmlT131fygMrOECH+bUXm6ihE+lL/ZvTbtAaiiS4sOAVIzMEg0
         zpww==
ARC-Authentication-Results: i=2; mx.google.com;
       arc=pass (i=1 spf=pass spfdomain=kernel.org);
       spf=pass (google.com: domain of lurodriguez@suse.de designates 195.135.220.15 as permitted sender) smtp.mailfrom=lurodriguez@suse.de
Received: from mx1.suse.de (mx2.suse.de. [195.135.220.15])
        by mx.google.com with ESMTPS id y75si2334662wme.66.2017.07.12.06.06.10
        for <akpm@linux-foundation.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 12 Jul 2017 06:06:11 -0700 (PDT)
Received-SPF: pass (google.com: domain of lurodriguez@suse.de designates 195.135.220.15 as permitted sender) client-ip=195.135.220.15;
Authentication-Results: mx.google.com;
       arc=pass (i=1 spf=pass spfdomain=kernel.org);
       spf=pass (google.com: domain of lurodriguez@suse.de designates 195.135.220.15 as permitted sender) smtp.mailfrom=lurodriguez@suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=mcgrof@kernel.org
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.org
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx1.suse.de (Postfix) with ESMTP id 799FBABB8
	for <akpm@linux-foundation.org>; Wed, 12 Jul 2017 13:06:10 +0000 (UTC)
Resent-From: "Luis R. Rodriguez" <mcgrof@suse.com>
Resent-Date: Wed, 12 Jul 2017 15:06:09 +0200
Resent-Message-ID: <20170712130609.GO21846@wotan.suse.de>
Resent-To: akpm@linux-foundation.org
Delivered-To: lurodriguez@imap.suse.de
Received: from prv3-mx.novell.com (novprvlin0680.provo.novell.com [130.57.1.108])
	by prv1-mh.provo.novell.com with ESMTP (NOT encrypted); Fri, 30 Jun 2017 16:44:39 -0600
Received: from mail-yw0-f174.google.com (209.85.161.174) by prv3-mx.novell.com (130.57.1.17) GWAVA SMTP; Fri, 30 Jun 2017 16:44:40 -0600
X-Spam_ID: str=0001.0A090205.5956D457.0271:SCFSTAT34825421,ss=1,re=-4.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-GWAVADAT: <keymat><rkey>EGHLrJI1cO0Hb4D/</rkey><gkey>3dd701ed13c99eb1e8f81487b9c947c26777ee7cd7bb0685a769f32e5c9c06ae</gkey><objectid>17boib3.17boib3.v6</objectid></keymat>
Received: by mail-yw0-f174.google.com with SMTP id l21so46044646ywb.1
        for <mcgrof@suse.com>; Fri, 30 Jun 2017 15:44:38 -0700 (PDT)
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: best guess record for domain of mcgrof@kernel.org designates 198.145.29.99 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
X-Received: by 10.129.161.196 with SMTP id y187mr20355957ywg.50.1498862677955;
        Fri, 30 Jun 2017 15:44:37 -0700 (PDT)
X-Forwarded-To: mcgrof@gmail.com, mcgrof@suse.com
X-Forwarded-For: mcgrof@do-not-panic.com mcgrof@gmail.com, mcgrof@suse.com
Delivered-To: mcgrof@do-not-panic.com
Received: by 10.37.190.3 with SMTP id h3csp5768404ybk;
        Fri, 30 Jun 2017 15:44:35 -0700 (PDT)
X-Received: by 10.202.84.214 with SMTP id i205mr10493690oib.158.1498862675645;
        Fri, 30 Jun 2017 15:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1498862675; cv=none;
        d=google.com; s=arc-20160816;
        b=kOK37615Q0fWigX9tf0jwa59plDBm6/DJqYPCSrZmi2CdV+Y1NPpCLvSS9ITJEmUYO
         dIxK9Q7kl0xP7dXZOSMFPfMJW+m2WcRLYGEWDpUFHKXt+aOzRXnLu+9roXQ6CDOo5hus
         TDhD75K/oJqH+8v4bRWJnUEUhNBkv9QeVsYOT+DyTuLZjdtPjp2d7nwYeJhbi55fiiNf
         ZITHRrJPF/qtAVhoigOn3ueoJGHb9SdmC/t1qzni/QHP+ts2dxvHyc/5JGmaPmmQbXSQ
         2IUcgPc/cD/qBbBemx6xSGbTgrBACkCWnJObAjBQJlkqCuv3jhVeHjY+hOIYHrEtkIPO
         DnCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dmarc-filter:delivered-to:arc-authentication-results;
        bh=S0/Fq0DIIZuKl0bNTOWv5hOReTEtHYRCCt6H3Mx8JI4=;
        b=bzbAhbKqK3PJzA6sjW4HziTcP3z0D7hKwZQhRADSl6y35x4baD1N7dGKZ9DV91tUER
         fS99IVmVRAEXs4fz2x7Z2HPAqky0OECN0GQqvZYJZtwVvYGPAFyGXufDvQ7i24/bcoKX
         wbtoUdoYqC+6mXj0cHbV8hvrV1kfiiPNj2j8PX4n6UKJID2Hskoa/zOL8qqQRqGwIH9y
         Gs6Jlm5GWZt527Nc2AT63J19d/yQWxavo3k1z9sRQJpfLsx+GTE1cX+iDvKhNnAvDqw1
         dzUvb+YjuDQVcHuaNm2t8xpuGB+qaZx2C1v6dqsJitbDlJvSgFvlx7/0J3u0GQgucHPf
         E2Hg==
ARC-Authentication-Results: i=1; mx.google.com;
       spf=pass (google.com: best guess record for domain of mcgrof@kernel.org designates 198.145.29.99 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
Received: from mail.kernel.org (mail.kernel.org. [198.145.29.99])
        by mx.google.com with ESMTPS id n5si5311166oia.294.2017.06.30.15.44.35
        for <mcgrof@do-not-panic.com>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jun 2017 15:44:35 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of mcgrof@kernel.org designates 198.145.29.99 as permitted sender) client-ip=198.145.29.99;
Received: by mail.kernel.org (Postfix)
	id EF5C822BE0; Fri, 30 Jun 2017 22:44:34 +0000 (UTC)
Delivered-To: mcgrof@kernel.org
Received: from garbanzo.do-not-panic.com (c-73-15-241-2.hsd1.ca.comcast.net [73.15.241.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 71C4022BDF;
	Fri, 30 Jun 2017 22:44:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71C4022BDF
To: akpm@linux-foundation.org
Cc: keescook@chromium.org, shuahkh@osg.samsung.com, shuah@kernel.org,
        sfr@canb.auug.org.au, orson.zhai@linaro.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: test_sysctl: add generic script to expand on tests
Date: Fri, 30 Jun 2017 15:44:27 -0700
Message-Id: <20170630224431.17374-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20170630224431.17374-1-mcgrof@kernel.org>
References: <20170629123527.2196820e70818aeab51338e5@linux-foundation.org>
 <20170630224431.17374-1-mcgrof@kernel.org>
Delivered-To: akpm@linux-foundation.org

This adds a generic script to let us more easily add more tests cases.
Since we really have only two types of tests cases just fold them into the
one file.  Each test unit is now identified into its separate function:

  # ./sysctl.sh -l
Test ID list:

TEST_ID x NUM_TEST
TEST_ID:   Test ID
NUM_TESTS: Number of recommended times to run the test

0001 x 1 - tests proc_dointvec_minmax()
0002 x 1 - tests proc_dostring()

For now we start off with what we had before, and run only each test once.
We can now watch a test case until it fails:

./sysctl.sh -w 0002

We can also run a test case x number of times, say we want to run
a test case 100 times:

./sysctl.sh -c 0001 100

To run a test case only once, for example:

./sysctl.sh -s 0002

The default settings are specified at the top of sysctl.sh.

Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/sysctl/Makefile         |   3 +-
 tools/testing/selftests/sysctl/common_tests     | 131 -------
 tools/testing/selftests/sysctl/run_numerictests |  10 -
 tools/testing/selftests/sysctl/run_stringtests  |  77 ----
 tools/testing/selftests/sysctl/sysctl.sh        | 494 ++++++++++++++++++++++++
 5 files changed, 495 insertions(+), 220 deletions(-)
 delete mode 100644 tools/testing/selftests/sysctl/common_tests
 delete mode 100755 tools/testing/selftests/sysctl/run_numerictests
 delete mode 100755 tools/testing/selftests/sysctl/run_stringtests
 create mode 100755 tools/testing/selftests/sysctl/sysctl.sh

diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
index b3c33e071f10..95c320b354e8 100644
--- a/tools/testing/selftests/sysctl/Makefile
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -4,8 +4,7 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
 all:
 
-TEST_PROGS := run_numerictests run_stringtests
-TEST_FILES := common_tests
+TEST_PROGS := sysctl.sh
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/sysctl/common_tests b/tools/testing/selftests/sysctl/common_tests
deleted file mode 100644
index b6862322962f..000000000000
--- a/tools/testing/selftests/sysctl/common_tests
+++ /dev/null
@@ -1,131 +0,0 @@
-#!/bin/sh
-
-TEST_FILE=$(mktemp)
-
-echo "== Testing sysctl behavior against ${TARGET} =="
-
-set_orig()
-{
-	echo "${ORIG}" > "${TARGET}"
-}
-
-set_test()
-{
-	echo "${TEST_STR}" > "${TARGET}"
-}
-
-verify()
-{
-	local seen
-	seen=$(cat "$1")
-	if [ "${seen}" != "${TEST_STR}" ]; then
-		return 1
-	fi
-	return 0
-}
-
-exit_test()
-{
-	if [ ! -z ${old_strict} ]; then
-		echo ${old_strict} > ${WRITES_STRICT}
-	fi
-	exit $rc
-}
-
-trap 'set_orig; rm -f "${TEST_FILE}"' EXIT
-
-rc=0
-
-echo -n "Writing test file ... "
-echo "${TEST_STR}" > "${TEST_FILE}"
-if ! verify "${TEST_FILE}"; then
-	echo "FAIL" >&2
-	exit 1
-else
-	echo "ok"
-fi
-
-echo -n "Checking sysctl is not set to test value ... "
-if verify "${TARGET}"; then
-	echo "FAIL" >&2
-	exit 1
-else
-	echo "ok"
-fi
-
-echo -n "Writing sysctl from shell ... "
-set_test
-if ! verify "${TARGET}"; then
-	echo "FAIL" >&2
-	exit 1
-else
-	echo "ok"
-fi
-
-echo -n "Resetting sysctl to original value ... "
-set_orig
-if verify "${TARGET}"; then
-	echo "FAIL" >&2
-	exit 1
-else
-	echo "ok"
-fi
-
-echo -n "Checking write strict setting ... "
-WRITES_STRICT="${SYSCTL}/kernel/sysctl_writes_strict"
-if [ ! -e ${WRITES_STRICT} ]; then
-	echo "FAIL, but skip in case of old kernel" >&2
-else
-	old_strict=$(cat ${WRITES_STRICT})
-	if [ "$old_strict" = "1" ]; then
-		echo "ok"
-	else
-		echo "FAIL, strict value is 0 but force to 1 to continue" >&2
-		echo "1" > ${WRITES_STRICT}
-	fi
-fi
-
-# Now that we've validated the sanity of "set_test" and "set_orig",
-# we can use those functions to set starting states before running
-# specific behavioral tests.
-
-echo -n "Writing entire sysctl in single write ... "
-set_orig
-dd if="${TEST_FILE}" of="${TARGET}" bs=4096 2>/dev/null
-if ! verify "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Writing middle of sysctl after synchronized seek ... "
-set_test
-dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 skip=1 2>/dev/null
-if ! verify "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Writing beyond end of sysctl ... "
-set_orig
-dd if="${TEST_FILE}" of="${TARGET}" bs=20 seek=2 2>/dev/null
-if verify "${TARGET}"; then
-        echo "FAIL" >&2
-        rc=1
-else
-        echo "ok"
-fi
-
-echo -n "Writing sysctl with multiple long writes ... "
-set_orig
-(perl -e 'print "A" x 50;'; echo "${TEST_STR}") | \
-	dd of="${TARGET}" bs=50 2>/dev/null
-if verify "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
diff --git a/tools/testing/selftests/sysctl/run_numerictests b/tools/testing/selftests/sysctl/run_numerictests
deleted file mode 100755
index c375ce0f4c15..000000000000
--- a/tools/testing/selftests/sysctl/run_numerictests
+++ /dev/null
@@ -1,10 +0,0 @@
-#!/bin/sh
-
-SYSCTL="/proc/sys/debug/test_sysctl/"
-TARGET="${SYSCTL}/int_0001"
-ORIG=$(cat "${TARGET}")
-TEST_STR=$(( $ORIG + 1 ))
-
-. ./common_tests
-
-exit_test
diff --git a/tools/testing/selftests/sysctl/run_stringtests b/tools/testing/selftests/sysctl/run_stringtests
deleted file mode 100755
index a6f2618afeaa..000000000000
--- a/tools/testing/selftests/sysctl/run_stringtests
+++ /dev/null
@@ -1,77 +0,0 @@
-#!/bin/sh
-
-SYSCTL="/proc/sys/debug/test_sysctl/"
-TARGET="${SYSCTL}/string_0001"
-ORIG=$(cat "${TARGET}")
-TEST_STR="Testing sysctl"
-
-. ./common_tests
-
-# Only string sysctls support seeking/appending.
-MAXLEN=65
-
-echo -n "Writing entire sysctl in short writes ... "
-set_orig
-dd if="${TEST_FILE}" of="${TARGET}" bs=1 2>/dev/null
-if ! verify "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Writing middle of sysctl after unsynchronized seek ... "
-set_test
-dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 2>/dev/null
-if verify "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Checking sysctl maxlen is at least $MAXLEN ... "
-set_orig
-perl -e 'print "A" x ('"${MAXLEN}"'-2), "B";' | \
-	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
-if ! grep -q B "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Checking sysctl keeps original string on overflow append ... "
-set_orig
-perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
-	dd of="${TARGET}" bs=$(( MAXLEN - 1 )) 2>/dev/null
-if grep -q B "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Checking sysctl stays NULL terminated on write ... "
-set_orig
-perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
-	dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
-if grep -q B "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-echo -n "Checking sysctl stays NULL terminated on overwrite ... "
-set_orig
-perl -e 'print "A" x ('"${MAXLEN}"'-1), "BB";' | \
-	dd of="${TARGET}" bs=$(( $MAXLEN + 1 )) 2>/dev/null
-if grep -q B "${TARGET}"; then
-	echo "FAIL" >&2
-	rc=1
-else
-	echo "ok"
-fi
-
-exit_test
diff --git a/tools/testing/selftests/sysctl/sysctl.sh b/tools/testing/selftests/sysctl/sysctl.sh
new file mode 100755
index 000000000000..cbe1345d7c1d
--- /dev/null
+++ b/tools/testing/selftests/sysctl/sysctl.sh
@@ -0,0 +1,494 @@
+#!/bin/bash
+# Copyright (C) 2017 Luis R. Rodriguez <mcgrof@kernel.org>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the Free
+# Software Foundation; either version 2 of the License, or at your option any
+# later version; or, when distributed separately from the Linux kernel or
+# when incorporated into other software packages, subject to the following
+# license:
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of copyleft-next (version 0.3.1 or later) as published
+# at http://copyleft-next.org/.
+
+# This performs a series tests against the proc sysctl interface.
+
+TEST_NAME="sysctl"
+TEST_DRIVER="test_${TEST_NAME}"
+TEST_DIR=$(dirname $0)
+TEST_FILE=$(mktemp)
+
+# This represents
+#
+# TEST_ID:TEST_COUNT:ENABLED
+#
+# TEST_ID: is the test id number
+# TEST_COUNT: number of times we should run the test
+# ENABLED: 1 if enabled, 0 otherwise
+#
+# Once these are enabled please leave them as-is. Write your own test,
+# we have tons of space.
+ALL_TESTS="0001:1:1"
+ALL_TESTS="$ALL_TESTS 0002:1:1"
+
+test_modprobe()
+{
+       if [ ! -d $DIR ]; then
+               echo "$0: $DIR not present" >&2
+               echo "You must have the following enabled in your kernel:" >&2
+               cat $TEST_DIR/config >&2
+               exit 1
+       fi
+}
+
+function allow_user_defaults()
+{
+	if [ -z $DIR ]; then
+		DIR="/sys/module/test_sysctl/"
+	fi
+	if [ -z $DEFAULT_NUM_TESTS ]; then
+		DEFAULT_NUM_TESTS=50
+	fi
+	if [ -z $SYSCTL ]; then
+		SYSCTL="/proc/sys/debug/test_sysctl"
+	fi
+	if [ -z $PROD_SYSCTL ]; then
+		PROD_SYSCTL="/proc/sys"
+	fi
+	if [ -z $WRITES_STRICT ]; then
+		WRITES_STRICT="${PROD_SYSCTL}/kernel/sysctl_writes_strict"
+	fi
+}
+
+function check_production_sysctl_writes_strict()
+{
+	echo -n "Checking production write strict setting ... "
+	if [ ! -e ${WRITES_STRICT} ]; then
+		echo "FAIL, but skip in case of old kernel" >&2
+	else
+		old_strict=$(cat ${WRITES_STRICT})
+		if [ "$old_strict" = "1" ]; then
+			echo "ok"
+		else
+			echo "FAIL, strict value is 0 but force to 1 to continue" >&2
+			echo "1" > ${WRITES_STRICT}
+		fi
+	fi
+}
+
+test_reqs()
+{
+	uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	if ! which perl 2> /dev/null > /dev/null; then
+		echo "$0: You need perl installed"
+		exit 1
+	fi
+}
+
+function load_req_mod()
+{
+	trap "test_modprobe" EXIT
+
+	if [ ! -d $DIR ]; then
+		modprobe $TEST_DRIVER
+		if [ $? -ne 0 ]; then
+			exit
+		fi
+	fi
+}
+
+set_orig()
+{
+	if [ ! -z $TARGET ]; then
+		echo "${ORIG}" > "${TARGET}"
+	fi
+}
+
+set_test()
+{
+	echo "${TEST_STR}" > "${TARGET}"
+}
+
+verify()
+{
+	local seen
+	seen=$(cat "$1")
+	if [ "${seen}" != "${TEST_STR}" ]; then
+		return 1
+	fi
+	return 0
+}
+
+test_rc()
+{
+	if [[ $rc != 0 ]]; then
+		echo "Failed test, return value: $rc" >&2
+		exit $rc
+	fi
+}
+
+test_finish()
+{
+	set_orig
+	rm -f "${TEST_FILE}"
+
+	if [ ! -z ${old_strict} ]; then
+		echo ${old_strict} > ${WRITES_STRICT}
+	fi
+	exit $rc
+}
+
+run_numerictests()
+{
+	echo "== Testing sysctl behavior against ${TARGET} =="
+
+	rc=0
+
+	echo -n "Writing test file ... "
+	echo "${TEST_STR}" > "${TEST_FILE}"
+	if ! verify "${TEST_FILE}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking sysctl is not set to test value ... "
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing sysctl from shell ... "
+	set_test
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Resetting sysctl to original value ... "
+	set_orig
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		exit 1
+	else
+		echo "ok"
+	fi
+
+	# Now that we've validated the sanity of "set_test" and "set_orig",
+	# we can use those functions to set starting states before running
+	# specific behavioral tests.
+
+	echo -n "Writing entire sysctl in single write ... "
+	set_orig
+	dd if="${TEST_FILE}" of="${TARGET}" bs=4096 2>/dev/null
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing middle of sysctl after synchronized seek ... "
+	set_test
+	dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 skip=1 2>/dev/null
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing beyond end of sysctl ... "
+	set_orig
+	dd if="${TEST_FILE}" of="${TARGET}" bs=20 seek=2 2>/dev/null
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing sysctl with multiple long writes ... "
+	set_orig
+	(perl -e 'print "A" x 50;'; echo "${TEST_STR}") | \
+		dd of="${TARGET}" bs=50 2>/dev/null
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	test_rc
+}
+
+run_stringtests()
+{
+	echo -n "Writing entire sysctl in short writes ... "
+	set_orig
+	dd if="${TEST_FILE}" of="${TARGET}" bs=1 2>/dev/null
+	if ! verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Writing middle of sysctl after unsynchronized seek ... "
+	set_test
+	dd if="${TEST_FILE}" of="${TARGET}" bs=1 seek=1 2>/dev/null
+	if verify "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking sysctl maxlen is at least $MAXLEN ... "
+	set_orig
+	perl -e 'print "A" x ('"${MAXLEN}"'-2), "B";' | \
+		dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+	if ! grep -q B "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking sysctl keeps original string on overflow append ... "
+	set_orig
+	perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+		dd of="${TARGET}" bs=$(( MAXLEN - 1 )) 2>/dev/null
+	if grep -q B "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking sysctl stays NULL terminated on write ... "
+	set_orig
+	perl -e 'print "A" x ('"${MAXLEN}"'-1), "B";' | \
+		dd of="${TARGET}" bs="${MAXLEN}" 2>/dev/null
+	if grep -q B "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	echo -n "Checking sysctl stays NULL terminated on overwrite ... "
+	set_orig
+	perl -e 'print "A" x ('"${MAXLEN}"'-1), "BB";' | \
+		dd of="${TARGET}" bs=$(( $MAXLEN + 1 )) 2>/dev/null
+	if grep -q B "${TARGET}"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "ok"
+	fi
+
+	test_rc
+}
+
+sysctl_test_0001()
+{
+	TARGET="${SYSCTL}/int_0001"
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	run_numerictests
+}
+
+sysctl_test_0002()
+{
+	TARGET="${SYSCTL}/string_0001"
+	ORIG=$(cat "${TARGET}")
+	TEST_STR="Testing sysctl"
+	# Only string sysctls support seeking/appending.
+	MAXLEN=65
+
+	run_numerictests
+	run_stringtests
+}
+
+list_tests()
+{
+	echo "Test ID list:"
+	echo
+	echo "TEST_ID x NUM_TEST"
+	echo "TEST_ID:   Test ID"
+	echo "NUM_TESTS: Number of recommended times to run the test"
+	echo
+	echo "0001 x $(get_test_count 0001) - tests proc_dointvec_minmax()"
+	echo "0002 x $(get_test_count 0002) - tests proc_dostring()"
+}
+
+test_reqs
+
+usage()
+{
+	NUM_TESTS=$(grep -o ' ' <<<"$ALL_TESTS" | grep -c .)
+	let NUM_TESTS=$NUM_TESTS+1
+	MAX_TEST=$(printf "%04d\n" $NUM_TESTS)
+	echo "Usage: $0 [ -t <4-number-digit> ] | [ -w <4-number-digit> ] |"
+	echo "		 [ -s <4-number-digit> ] | [ -c <4-number-digit> <test- count>"
+	echo "           [ all ] [ -h | --help ] [ -l ]"
+	echo ""
+	echo "Valid tests: 0001-$MAX_TEST"
+	echo ""
+	echo "    all     Runs all tests (default)"
+	echo "    -t      Run test ID the number amount of times is recommended"
+	echo "    -w      Watch test ID run until it runs into an error"
+	echo "    -c      Run test ID once"
+	echo "    -s      Run test ID x test-count number of times"
+	echo "    -l      List all test ID list"
+	echo " -h|--help  Help"
+	echo
+	echo "If an error every occurs execution will immediately terminate."
+	echo "If you are adding a new test try using -w <test-ID> first to"
+	echo "make sure the test passes a series of tests."
+	echo
+	echo Example uses:
+	echo
+	echo "$TEST_NAME.sh            -- executes all tests"
+	echo "$TEST_NAME.sh -t 0002    -- Executes test ID 0002 number of times is recomended"
+	echo "$TEST_NAME.sh -w 0002    -- Watch test ID 0002 run until an error occurs"
+	echo "$TEST_NAME.sh -s 0002    -- Run test ID 0002 once"
+	echo "$TEST_NAME.sh -c 0002 3  -- Run test ID 0002 three times"
+	echo
+	list_tests
+	exit 1
+}
+
+function test_num()
+{
+	re='^[0-9]+$'
+	if ! [[ $1 =~ $re ]]; then
+		usage
+	fi
+}
+
+function get_test_count()
+{
+	test_num $1
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	LAST_TWO=${TEST_DATA#*:*}
+	echo ${LAST_TWO%:*}
+}
+
+function get_test_enabled()
+{
+	test_num $1
+	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	echo ${TEST_DATA#*:*:}
+}
+
+function run_all_tests()
+{
+	for i in $ALL_TESTS ; do
+		TEST_ID=${i%:*:*}
+		ENABLED=$(get_test_enabled $TEST_ID)
+		TEST_COUNT=$(get_test_count $TEST_ID)
+		if [[ $ENABLED -eq "1" ]]; then
+			test_case $TEST_ID $TEST_COUNT
+		fi
+	done
+}
+
+function watch_log()
+{
+	if [ $# -ne 3 ]; then
+		clear
+	fi
+	date
+	echo "Running test: $2 - run #$1"
+}
+
+function watch_case()
+{
+	i=0
+	while [ 1 ]; do
+
+		if [ $# -eq 1 ]; then
+			test_num $1
+			watch_log $i ${TEST_NAME}_test_$1
+			${TEST_NAME}_test_$1
+		else
+			watch_log $i all
+			run_all_tests
+		fi
+		let i=$i+1
+	done
+}
+
+function test_case()
+{
+	NUM_TESTS=$DEFAULT_NUM_TESTS
+	if [ $# -eq 2 ]; then
+		NUM_TESTS=$2
+	fi
+
+	i=0
+	while [ $i -lt $NUM_TESTS ]; do
+		test_num $1
+		watch_log $i ${TEST_NAME}_test_$1 noclear
+		RUN_TEST=${TEST_NAME}_test_$1
+		$RUN_TEST
+		let i=$i+1
+	done
+}
+
+function parse_args()
+{
+	if [ $# -eq 0 ]; then
+		run_all_tests
+	else
+		if [[ "$1" = "all" ]]; then
+			run_all_tests
+		elif [[ "$1" = "-w" ]]; then
+			shift
+			watch_case $@
+		elif [[ "$1" = "-t" ]]; then
+			shift
+			test_num $1
+			test_case $1 $(get_test_count $1)
+		elif [[ "$1" = "-c" ]]; then
+			shift
+			test_num $1
+			test_num $2
+			test_case $1 $2
+		elif [[ "$1" = "-s" ]]; then
+			shift
+			test_case $1 1
+		elif [[ "$1" = "-l" ]]; then
+			list_tests
+		elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
+			usage
+		else
+			usage
+		fi
+	fi
+}
+
+test_reqs
+allow_user_defaults
+check_production_sysctl_writes_strict
+load_req_mod
+
+trap "test_finish" EXIT
+
+parse_args $@
+
+exit 0
-- 
2.11.0


Patches currently in -mm which might be from mcgrof@kernel.org are

sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
test_sysctl-add-dedicated-proc-sysctl-test-driver.patch
test_sysctl-add-generic-script-to-expand-on-tests.patch
test_sysctl-test-against-page_size-for-int.patch
test_sysctl-add-simple-proc_dointvec-case.patch
test_sysctl-add-simple-proc_douintvec-case.patch
test_sysctl-test-against-int-proc_dointvec-array-support.patch
maintainers-give-kmod-some-maintainer-love.patch
kmod-add-test-driver-to-stress-test-the-module-loader.patch
kmod-throttle-kmod-thread-limit.patch

