Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BA0C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbhKXVrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241449AbhKXVrH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:47:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4325360200;
        Wed, 24 Nov 2021 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637790237;
        bh=qvZbQsFC+jQMOFoTRNkf8Xr89jb8O5jY1I/phJQztXg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=cfSupiFiT+hMZt4x+H7wbUMQS27towJ3pTquAqVFm4clqCdo3/wY4wIk/YNPCeX/L
         2syMa3TePq0PJdPF1Y3+bXaS//46rpzQWkt+0h/QN51Sqq39JuJ9E2ZkI5eahnKOP2
         /uLI5J9pH4/XBumclPvXv/gop+8OGbu0zkmlRY6AAIuxgIeAk/MY8+xzIhIqI3d/Os
         3Dr4/RmKHxm2c+fAg03kGUYZuZgMqeWAGP9FUu81Le07PPU0dO67spSqBX+/CajZuZ
         ZdvLdhd34pLRimQ+wUBrNHHGwX7qp5VfY/rze6CEp1agz1Diuk/89ffNzrQkao8u2G
         8L2bhllqVVkkA==
Date:   Wed, 24 Nov 2021 22:43:54 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Marco Elver <elver@google.com>
cc:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, glider@google.com, jirislaby@kernel.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject: Re: + kasan-distinguish-kasan-report-from-generic-bug.patch added
 to -mm tree
In-Reply-To: <CANpmjNPnepsX=pt3FYkpUmSU3ZU2VSCraOyNKfUXveLhR+b15g@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2111242242090.16505@cbobk.fhfr.pm>
References: <20211124212054.GQBSK_Ilb%akpm@linux-foundation.org> <CANpmjNPnepsX=pt3FYkpUmSU3ZU2VSCraOyNKfUXveLhR+b15g@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Nov 2021, Marco Elver wrote:

> Oh dear, I don't think we were ready -- this patch would cause all
> kinds of issues:
> https://lkml.kernel.org/r/CANpmjNOHN7SWu-pKGr9EBb3=in2AWiGmqNb6sYwhebGtRk+1uQ@mail.gmail.com

Yeah, I wasn't expecting it to be queued right away after you've raised 
your concerns indeed :)

I still hate the fact that it's pretending that real BUG() is happening, 
while it's in fact not, in passion (yes, it did bite me :) ), with 
passion.

How many known tools are there that are relying on this format?

Thanks,

-- 
Jiri Kosina
SUSE Labs

