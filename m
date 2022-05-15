Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2ACC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 15 May 2022 12:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiEOM2Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 15 May 2022 08:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiEOM2Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 15 May 2022 08:28:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D69227B00
        for <mm-commits@vger.kernel.org>; Sun, 15 May 2022 05:28:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m12so12011773plb.4
        for <mm-commits@vger.kernel.org>; Sun, 15 May 2022 05:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=gO56sDltrT+1Ad3mlKfXpXWBHMblfINuk9YC/Rq6QO4=;
        b=NOg1kLxULkmQkuNfaZhpicAaMOWgbi6GrJnApEPSa5orSezgn7pGRgbdMksa+L8S8o
         rg6f0N2eIxGN3xjgbbpoY6MHyAia87k1QXRmofFY564lpIyK/V742haG9VEN9mhsitu7
         7/awJmZpunCcrplFU9PRPuTRzwVEO9+6/LBxTpgf/xG6tfrWiUduqnJ0J/ApHi5fSard
         qEGH3KroubPaPIBpP2eXxJx3QiwiX/zaeBzoSS5KWjarVDdwRo998n+MwFrC3RzTm8Ib
         jwQAxjh6zpnGGeYCQOz6FEiv8EfgXo4Kz9llSmIy4e9qinstvGLEfHZVeAC0xOKpcH75
         pAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=gO56sDltrT+1Ad3mlKfXpXWBHMblfINuk9YC/Rq6QO4=;
        b=5QWagQ1UdZ4BCcgf/VIBPO20ON11+5rsXg6iorNAjzsW3/mD0XgvbW+YDUvnr5Nxo6
         mjfzxAG4xP3AJ9ukZe20CVg1ggHRa3QXHBV8AtlnrWLW0dReG7nbEE+60y/7Eakp1bjE
         8pRweItSlEbmAvCydKgrvl079mihzxB4c3WMhbQeEpxZT+g1Rt8jNsfdwACm0mSIFUkg
         i0ET/PmMIwG50Lq1GhaemHSMo3TbLZNJI01GhU5fvXSolp44fP6POyceV3Jfg0hbWEif
         8wS3m41mL5Q6ln1nrI7F99iJFMniZrQPS3s1asnncrOrI6fX7j34a4n7V4AwZ7BEp6k4
         MhrA==
X-Gm-Message-State: AOAM532mzCQl9ZRpteO7YGPtlJ74BJBa3IDAkWPvkcMuPymlnwLzA10M
        wvintwvsL6U3wBLvCm7AbAuGL1ik1NE=
X-Google-Smtp-Source: ABdhPJx62lqLqR1mnlBiuYGKRBQLpZz8AjVRyMxenoWQIQNk5pJLQ4x6jO0Rg1VsYElCLMcP3E5m/w==
X-Received: by 2002:a17:903:40cf:b0:161:6650:e244 with SMTP id t15-20020a17090340cf00b001616650e244mr3327486pld.128.1652617694881;
        Sun, 15 May 2022 05:28:14 -0700 (PDT)
Received: from [192.168.43.80] (subs09a-223-255-225-69.three.co.id. [223.255.225.69])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090aa58300b001dcf8960a13sm6519911pjq.40.2022.05.15.05.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 05:28:14 -0700 (PDT)
Message-ID: <d718a929-ad36-2e7b-973d-8aa90c66f4d3@gmail.com>
Date:   Sun, 15 May 2022 19:28:10 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     linux-mm@kvack.org
Cc:     mm-commits@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Visible (literal) \n on mm-commits notification
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

I saw recent messages from mm-commits@vger.kernel.org and I noticed
literal "\n" on your notifications; that are:

  - "This patch was dropped because it was merged into the mm-nonmm-stable
     branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm"
     (like [1])
  - "This patch was dropped because it was merged into the mm-stable
     branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm"
     (like [2])

Thanks.

[1]: https://lore.kernel.org/mm-commits/20220513192342.7C8A0C34100@smtp.kernel.org/T/#u
[2]: https://lore.kernel.org/mm-commits/20220514195527.3A065C34100@smtp.kernel.org/T/#u

-- 
An old man doll... just what I always wanted! - Clara
