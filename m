Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62536EE49AE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 18:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjHVS5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjHVS5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 14:57:49 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BA1137
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 11:57:47 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1ccc0d2e697so92618fac.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 11:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692730667; x=1693335467;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r7Bg8OYIbg31t6o6+fzirGpubNXe6uDpUCM7YS+JnYs=;
        b=ViJtIuw5INbxvLv/s6ybR/+uSuaQ/dImygTqLa9hVB4xNpIDjlSKrLANrbqa+NjpTT
         aKAMCVkDpLP2bKZ6EqrLbrQXCR1AuLGSraG3fs2PmNyORN0Pb+O2Axunmzdlxcp21l4v
         vMojkSWXG8BtqGdZIwHy1If6AdjyJm9tCA8hJHIR5SGHfjGzKeJJy9LLW3wrRPG5FHnp
         9WoAg8NWGjJ4rP7k9AHIdWR0aoq8Yhdwl/bdCNVZ1TLVi84iAIvf4mYbfd6D9hSB15CX
         oiyUi9xqfBUpAlKsi4oMx/42CZaplZrbwFoP75zzkFrNKnqbqmqyqHES6KqFv6J/mlCp
         X3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692730667; x=1693335467;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7Bg8OYIbg31t6o6+fzirGpubNXe6uDpUCM7YS+JnYs=;
        b=ZowRs+Es471vSD7xQgriFdgtaMTCAxAUcWGjyLpjIpoiWbCEGLMvrAawHVXiFJLKmo
         O35XhLgNWofLwI3cQQRTA//mtBo0IC0/ZBKO8523wLU2R3ClvGW7uwFLsasGeM14G65o
         y7LavdKQieIfbRPigrPkAv8Ntz5E/yPtjjX3WXtseeMZQ9Zlr0qQHPg0gI8P93ow74zZ
         UrbK4oIVLGEdh3poQoKJOLsMn7nxStt2KQ1BRRSXZeXj5PP9n/1ZO1DjcWbKQcQeY+5a
         85z+Uy2ibnEIFHM5uWT94qIZ/MuveWSm0WzH3NxfkYNFYIiQQ0iYgeuGY8dEoD6VyE91
         ug8Q==
X-Gm-Message-State: AOJu0YzCFPck6JCckM3sXBHLcreHgs8Bx9ZmZqVp8WqrNTRy88WoCGua
        4W1LXp/OXz/NUW2R1pY+lM/n4f0y+93opmdIvKdNVcluKNM=
X-Google-Smtp-Source: AGHT+IEVilmSURIw9GmvcZb5gBXIgdOZE4wefU7DMQBNRk6HQyJDISfDtXgU4ZSGxXxFRic48hjARgAVaKe0GhFAnT4=
X-Received: by 2002:a05:6870:912b:b0:1b4:66e6:cf51 with SMTP id
 o43-20020a056870912b00b001b466e6cf51mr13338344oae.15.1692730666892; Tue, 22
 Aug 2023 11:57:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5797:0:b0:4f0:1250:dd51 with HTTP; Tue, 22 Aug 2023
 11:57:46 -0700 (PDT)
In-Reply-To: <ZOUDI/w51dJG7hOE@casper.infradead.org>
References: <20230822184454.D1B73C433C7@smtp.kernel.org> <ZOUDI/w51dJG7hOE@casper.infradead.org>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Tue, 22 Aug 2023 20:57:46 +0200
Message-ID: <CAGudoHEBb4qDyyTKAtUx8-vAd312FO9vH4bnTBPHuHttV_2HiQ@mail.gmail.com>
Subject: Re: + maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch
 added to mm-unstable branch
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, Liam.Howlett@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 8/22/23, Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Aug 22, 2023 at 11:44:54AM -0700, Andrew Morton wrote:
>> ------------------------------------------------------
>> From: Mateusz Guzik <mjguzik@gmail.com>
>> Subject: maple_tree: shrink struct maple_tree from 24 to 16 bytes on LP64
>> Date: Tue, 22 Aug 2023 00:51:45 +0200
>>
>> by plugging a padding hole.
>>
>> Link:
>> https://lkml.kernel.org/r/20230821225145.2169848-1-mjguzik@gmail.com
>> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>
> Could we perhaps amend the commit log?
>
> Subject: maple_tree: Shrink struct maple_tree
>
> Pack the members of struct maple_tree to avoid holes on 64-bit.
> The size shrinks from 24 to 16 bytes which will save eight bytes
> in every structure which embeds it.
>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>

Is this kind of descriptiveness expected? I am only a sojourner here,
but even then I suspect I'm going to run into a bunch of other
trivialities of this sort.

fwiw I would avoid the term 'pack' as it suggests the attribute
"packed", perhaps:

> Reorder the members of struct maple_tree to avoid holes on 64-bit.
> The size shrinks from 24 to 16 bytes which will save eight bytes
> in every structure which embeds it.

-- 
Mateusz Guzik <mjguzik gmail.com>
