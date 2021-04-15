Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA08AC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 21:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6ED610CE
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhDOVU7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 17:20:59 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.94]:24439 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234959AbhDOVU6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Apr 2021 17:20:58 -0400
X-Greylist: delayed 1239 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 17:20:58 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 61F0C115C6C
        for <mm-commits@vger.kernel.org>; Thu, 15 Apr 2021 15:59:53 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id X95dliO76mJLsX95dlA75n; Thu, 15 Apr 2021 15:59:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7wg8JtA3ktzmOrMOS0BzL+zMYZ8TwyfQA0eGBpsn9PM=; b=IRqjj2LHpmls1MTUV1SGS9Au9c
        KNNqihPbbvtiRo6/YbioezBL9yi2MfAikJOvPgf05dHGOkitSL/OWgjGYkpc0WsjLfx1dsgxZdOJp
        ICUg+c/kCjc0pIBcYD9oEMZN+5sIs1694VwaLt2IjCAObtgSRXrrvQkSMu+mfLdCf56JOWf1GXEnQ
        6+Ei7tILte17hvJqvkH4MmYu0nmetnnUUFh1KbbN0h2WoegGGtyuNi4V9u8ilQQlY2vjj5CqSoLZe
        DcmTpCmW84DDgtVgOhpnSlpe8Ye3pb/pzlmMSpJK/8hEuxdSny6gtugUbEZE1GgYkmU+5q1x3a6Kp
        3JVxxRSg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:47406 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lX95c-003IuO-3S; Thu, 15 Apr 2021 15:59:52 -0500
Subject: Re: + hpfs-replace-one-element-array-with-flexible-array-member.patch
 added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        mikulas@artax.karlin.mff.cuni.cz, gustavoars@kernel.org
References: <20210415202215.f693g%akpm@linux-foundation.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <c5d9c064-c2f6-bb6f-c4fc-bd4c45248c0e@embeddedor.com>
Date:   Thu, 15 Apr 2021 16:00:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415202215.f693g%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lX95c-003IuO-3S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:47406
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 4/15/21 15:22, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: hpfs: replace one-element array with flexible-array member
> has been added to the -mm tree.  Its filename is
>      hpfs-replace-one-element-array-with-flexible-array-member.patch

Thanks, Andrew!

--
Gustavo
