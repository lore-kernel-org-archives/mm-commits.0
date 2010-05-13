From: akpm@linux-foundation.org
Subject: + kfifo-fix-kfifo-miss-use-of-nozamic.patch added to -mm tree
Date: Thu, 13 May 2010 14:35:09 -0700
Message-ID: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758837Ab0EMVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, greg@kroah.com


The patch titled
     kfifo: fix kfifo miss use of nozami.c
has been added to the -mm tree.  Its filename is
     kfifo-fix-kfifo-miss-use-of-nozamic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix kfifo miss use of nozami.c
From: Stefani Seibold <stefani@seibold.net>

There are different types of a fifo which can not handled in C without a
lot of overhead.  So i decided to write the API as a set of macros, which
is the only way to do a kind of template meta programming without C++. 
This macros handles the different types of fifos in a transparent way.

There are a lot of benefits:

- Compile time handling of the different fifo types
- Better performance (a save put or get of an integer does only generate 
  9 assembly instructions on a x86) 
- Type save
- Cleaner interface, the additional kfifo_..._rec() functions are gone
- Easier to use
- Less error prone
- Different types of fifos: it is now possible to define a int fifo or
  any other type. See below for an example.
- Smaller footprint for none byte type fifos
- No need of creating a second hidden variable, like in the old DEFINE_KFIFO

The API was not changed.

There are now real in place fifos where the data space is a part of the
structure.  The fifo needs now 20 byte plus the fifo space.  Dynamic
assigned or allocated create a little bit more code.

Most of the macros code will be optimized away and simple generate a
function call.  Only the really small one generates inline code.

Additionally you can now create fifos for any data type, not only the
"unsigned char" byte streamed fifos.

There is also a new kfifo_put and kfifo_get function, to handle a single
element in a fifo.  This macros generates inline code, which is lit bit
larger but faster.

I know that this kind of macros are very sophisticated and not easy to
maintain.  But i have all tested and it works as expected.  I analyzed the
output of the compiler and for the x86 the code is as good as hand written
assembler code.  For the byte stream fifo the generate code is exact the
same as with the current kfifo implementation.  For all other types of
fifos the code is smaller before, because the interface is easier to use. 


The main goal was to provide an API which is very intuitive, save and easy
to use.  So linux will get now a powerful fifo API which provides all what
a developer needs.  This will save in the future a lot of kernel space,
since there is no need to write an own implementation.  Most of the device
driver developers need a fifo, and also deep kernel development will gain
benefit from this API.


Here are the results of the text section usage:

Example 1:
                        kfifo_put/_get  kfifo_in/out    current kfifo
dynamic allocated       0x000002a8      0x00000291      0x00000299
in place                0x00000291      0x0000026e      0x00000273

kfifo.c                 new             old
text section size       0x00000be5      0x000008b2

As you can see, kfifo_put/kfifo_get creates a little bit more code than
kfifo_in/kfifo_out, but it is much faster (the code is inline).

The code is complete hand crafted and optimized.  The text section size is
as small as possible.  You get all the fifo handling in only 3 kb.  This
includes type safe fix size records, dynamic records and DMA handling.

This should be the final version. All requested features are implemented.

Note: Most features of this API doesn't have any users.  All functions
which are not used in the next 9 months will be removed.  So, please adapt
your drivers and other sources as soon as possible to the new API and post
it.  

This are the features which are currently not used in the kernel:

kfifo_to_user()
kfifo_from_user()
kfifo_dma_....() macros
kfifo_esize()
kfifo_recsize()
kfifo_put()
kfifo_get()

The fixed size record elements, exclude "unsigned char" fifo's and the
variable size records fifo's


This patch:

User of the kernel fifo should never bypass the API and directly access
the fifo structure.  Otherwise it will be very hard to maintain the API.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-fix-kfifo-miss-use-of-nozamic drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-fix-kfifo-miss-use-of-nozamic
+++ a/drivers/char/nozomi.c
@@ -1741,8 +1741,7 @@ static int ntty_write_room(struct tty_st
 	if (dc) {
 		mutex_lock(&port->tty_sem);
 		if (port->port.count)
-			room = port->fifo_ul.size -
-					kfifo_len(&port->fifo_ul);
+			room = kfifo_avail(&port->fifo_ul);
 		mutex_unlock(&port->tty_sem);
 	}
 	return room;
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
linux-next.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch
kfifo-fix-kfifo-miss-use-of-nozamic.patch
kfifo-add-the-new-generic-kfifo-api.patch
kfifo-replace-the-old-non-generic-api.patch
kfifo-add-example-files-to-the-kernel-sample-directory.patch

