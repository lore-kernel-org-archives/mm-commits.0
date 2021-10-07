Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102DFC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B4160F6F
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhJGSaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 14:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhJGSaY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2021 14:30:24 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C503C061570
        for <mm-commits@vger.kernel.org>; Thu,  7 Oct 2021 11:28:30 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id l7so26691671edq.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Oct 2021 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bNsBpyB/Z8Q4Y+w/HCZCltZQE/gelZrKkTlPqUXS6kk=;
        b=RDt2L4i2CSEXQXuLi+cmYfymfWyucj++vb8o3+RCGyYhUeNGzPHiGVDduDnjVZtHVG
         gvWHTNtXbpW3WBGUnrXALD3ji+dWXOi03gZp9QyQfqgxu8wrt/SvNQrGcBksuLhNrWlk
         TKdfvNl347fOps3hWz+Qzp5/jOqi927z5cFv71yd9etratkby/fEGJdZ4qaJxM51Uz1I
         l5hjMw4+RLasadpMBLrvyL/10acGZ+Gsa+xwKtCyvvxOaSVCM0YbiGI5iOjizyeTEfYY
         S0DLJkw+6vmJ/K8KpEob7sCxeXe0AY5KPRL/QkN5UwpiaW+aB9XY45/GCpos4GsAAiVj
         6wpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bNsBpyB/Z8Q4Y+w/HCZCltZQE/gelZrKkTlPqUXS6kk=;
        b=0Gl76Xzlp33y+JW0bAmtSzROvNvWifcHhMh3ov9Mz6TGIowABze6F+AFPm16Rk/t7l
         OGvOZzFnzhXTixpmX2cCzfClWhO9Pi+TaRHIzj2umO19V7am4Ipxb4I4fnD4CoJimkqA
         2ns860Qr9+YRP4MhL0da8hWgWa9YatlhYPmX+tuv6XA26IiGogotNYr15mfkPk0bHZcH
         00W2D+iXmsOO3XWqRyzyQFsR03266owuQ6PKVYLJjwtb9TdG516BMWZzp56xUkmmPOQf
         HblRVQHlfqYTyu1IgqvJuhvfewabjWI5kMRDs/j1PIXaWu5iACbcasR4Xn7NaeA0ZOCm
         jVQg==
X-Gm-Message-State: AOAM53276+hNH0jDhh6/iorX0O4uBMQMkfSPz86jHK98Q/7EBV+ermeO
        1NMRFF1SPnKJDVrIO9LG7w==
X-Google-Smtp-Source: ABdhPJy2UouizwjS3Odr/FV8ny0llMvkWNaBrXraFbyvnET9vyiYbSOUykJCwnqmyniOG5fsAuT1/w==
X-Received: by 2002:a17:906:5590:: with SMTP id y16mr7507058ejp.286.1633631308797;
        Thu, 07 Oct 2021 11:28:28 -0700 (PDT)
Received: from localhost.localdomain ([46.53.254.50])
        by smtp.gmail.com with ESMTPSA id g21sm94550edr.7.2021.10.07.11.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 11:28:28 -0700 (PDT)
Date:   Thu, 7 Oct 2021 21:28:26 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     akpm@linux-foundation.org
Cc:     christian.brauner@ubuntu.com, ebiederm@xmission.com,
        fweimer@redhat.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject: Re: + procfs-do-not-list-tid-0-in-proc-pid-task.patch added to -mm
 tree
Message-ID: <YV88Sqq7uMgziYwK@localhost.localdomain>
References: <20210929232038.o0_ct-q8J%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210929232038.o0_ct-q8J%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 29, 2021 at 04:20:38PM -0700, akpm@linux-foundation.org wrote:
> Subject: procfs: do not list TID 0 in /proc/<pid>/task
> 
> If a task exits concurrently, task_pid_nr_ns may return 0.

So easy to reproduce, wonder why didn't anyone report it earlier.

Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
