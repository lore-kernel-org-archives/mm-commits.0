Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29881C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 02:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBZCoL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 21:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBZCoK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 21:44:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D8EE3A3
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 18:44:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id d30so12547681eda.4
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 18:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxKXjplYACiN9YJ/Px+I865g0ZB/otSoANGJeT3uzhs=;
        b=ZZeR9NrMwOaCFPprgHZ/OmapCRI3dTo+lQYefzW6ZLqWOCyZ3ci6NdLzVqUr/37pxs
         lw/zA0D8WdBuAjR40t4iLU6BduMi7UY53B6jlLq5M8sTPQxgI7SFy0KteypniL5J//QY
         mkd3wwJFchITDtAma/D4k9xVBhfmyDWPtluA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxKXjplYACiN9YJ/Px+I865g0ZB/otSoANGJeT3uzhs=;
        b=Yb/wPYeGiWguGLDsjTtweDdruIohc+3PPffiwGmdEbCW2sEUX6gUoQ9RlrmCBHPuiq
         +0OpgdqhSmreIjNA26tW+LEP4WHK7YyJvPs83VsOtYLsFhzJp/DmDbcJN6DpF4THAV36
         URkV6fhUD8re8NzK2PoAWkhQmaRGd4ANfVqJ9QrjIagl7Q1v6Ye56IKE96yUB7GAy/sS
         BayWjgOP7gwn7cuFY3geHTskvtB+JOSxOeQmtQphDYfOykSAFKKLIvoxCBRYiZj+CMDz
         9YgleOZTVJnG9MMHhWaFuKgBN7C9wbA0v+JtlRRD9jfdudBRctyA8fk3F6JP6iYsV6ce
         eooA==
X-Gm-Message-State: AO0yUKVgV4sysQFX4d6ded66Z/N3cSKjfv/bnohaaNnrybAkFxa+7DLf
        Jb72UQiGDRRzbUJrByXEiZiJlFI6qa/czc5LbpTO7g==
X-Google-Smtp-Source: AK7set9m7MsvN7uadiDgW1cVqBWgQ5ErlyPy5Dr/KFBZJp81NW6rz0HYCGNMH1xaHMlFn24jVTndJg==
X-Received: by 2002:a17:907:d87:b0:885:5682:7e52 with SMTP id go7-20020a1709070d8700b0088556827e52mr35037187ejc.13.1677379446829;
        Sat, 25 Feb 2023 18:44:06 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id s24-20020a1709060c1800b008ddf3476c75sm1464878ejf.92.2023.02.25.18.44.06
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 18:44:06 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id f13so12498154edz.6
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 18:44:06 -0800 (PST)
X-Received: by 2002:a50:d619:0:b0:4ab:3a49:68b9 with SMTP id
 x25-20020a50d619000000b004ab3a4968b9mr9683417edi.5.1677379445707; Sat, 25 Feb
 2023 18:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
In-Reply-To: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 18:43:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
Message-ID: <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 20, 2023 at 1:52=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Linus, please merge this cycle's MM updates.

Hmm. Just a note to let you know that I'm bisecting google-chrome
dumping core, and it seems to be due to something in this pull.

I've got a couple of hundred commits to go, so let's see what it
bisects to, but right now all the bad state came from this pull,
afaik.

Maybe it's a false alarm, but it seems to be consistent so far.

Will update when I've bisected closer.

                  Linus
