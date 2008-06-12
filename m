From: akpm@linux-foundation.org
Subject: + repeatable-slab-corruption-with-ltp-msgctl08.patch added to -mm tree
Date: Thu, 12 Jun 2008 12:21:44 -0700
Message-ID: <200806121921.m5CJLjEc002399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbYFLTVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 15:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Re: repeatable slab corruption with LTP msgctl08
has been added to the -mm tree.  Its filename is
     repeatable-slab-corruption-with-ltp-msgctl08.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Re: repeatable slab corruption with LTP msgctl08
From: Manfred Spraul <manfred@colorfullife.com>

This is a multi-part message in MIME format.
--------------090503070905060005030200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Thu, 12 Jun 2008 20:33:23 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
>
>
>> Pekka J Enberg wrote:
>>
>>> Hi Andrew,
>>>
>>> On Wed, 11 Jun 2008, Andrew Morton wrote:
>>>
>>>
>>>> version is ltp-full-20070228 (lots of retro-computing there).
>>>>
>>>> Config is at http://userweb.kernel.org/~akpm/config-vmm.txt
>>>>
>>>> ./testcases/bin/msgctl08 crashes after ten minutes or so:
>>>>
>>>> slab: Internal list corruption detected in cache 'size-128'(26), slabp f2905000(20). Hexdump:
>>>>
>>>> 000: 00 e0 12 f2 88 32 c0 f7 88 00 00 00 88 50 90 f2
>>>> 010: 14 00 00 00 0f 00 00 00 00 00 00 00 ff ff ff ff
>>>> 020: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
>>>> 030: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
>>>> 040: fd ff ff ff fd ff ff ff 00 00 00 00 fd ff ff ff
>>>> 050: fd ff ff ff fd ff ff ff 19 00 00 00 17 00 00 00
>>>> 060: fd ff ff ff fd ff ff ff 0b 00 00 00 fd ff ff ff
>>>> 070: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
>>>> 080: 10 00 00 00
>>>>
>>>>
>>> Looking at the above dump, slabp->free is 0x0f and the bufctl it points to
>>> is 0xff ("BUFCTL_END") which marks the last element in the chain. This is
>>> wrong as the total number of objects in the slab (cachep->num) is 26 but
>>> the number of objects in use (slabp->inuse) is 20. So somehow you have
>>> managed to lost 6 objects from the bufctl chain.
>>>
>>>
>>>
>> Hmm. double kfree() should be cached by the redzone code.
>> And I disagree with your link interpretation:
>>
>> 000: 00 e0 12 f2 88 32 c0 f7 88 00 00 00 88 50 90 f2
>> 010:
>> inuse: 14 00 00 00 (20 entries in use, 6 should be free)
>> free:  0f 00 00 00
>> nodeid: 00 00 00 00
>> bufctl[0x00] ff ff ff ff 020: fd ff ff ff fd ff ff ff fd ff ff ff
>> bufctl[0x4] fd ff ff ff  030: fd ff ff ff fd ff ff ff fd ff ff ff
>> bufctl[0x8] fd ff ff ff  040: fd ff ff ff fd ff ff ff 00 00 00 00
>> bufctl[0x0c] fd ff ff ff 050: fd ff ff ff fd ff ff ff 19 00 00 00
>> bufctl[0x10] 17 00 00 00 060: fd ff ff ff fd ff ff ff 0b 00 00 00
>> bufctl[0x14] fd ff ff ff 070: fd ff ff ff fd ff ff ff fd ff ff ff
>> bufctl[0x18] fd ff ff ff 080: 10 00 00 00
>>
>> free: points to entry 0x0f.
>> bufctl[0x0f] is 0x19, i.e. it points to entry 0x19
>> 0x19 points to 0x10
>> 0x10 points to 0x17
>> 0x17 is a BUFCTL_ACTIVE - that's a bug.
>> but: 0x13 is a valid link entry, is points to 0x0b
>> 0x0b points to 0x00, which is BUFCTL_END.
>>
>> IMHO the most probable bug is a single bit error:
>> bufctl[0x10] should be 0x13 instead of 0x17.
>>
>> What about printing all redzone words? That would allow us to validate the bufctl chain.
>>
>> Andrew: Could you post the new oops?
>>
>>
>
> umm, what new oops?
>
> I have four saved away here:
>
> slab: Internal list corruption detected in cache 'size-96'(32), slabp ea2a5040(28). Hexdump:
>
> 000: 20 90 b5 ec 88 54 80 f7 e0 00 00 00 e0 50 2a ea
> 010: 1c 00 00 00 17 00 00 00 00 00 00 00 fd ff ff ff
> 020: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 030: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 040: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 050: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 060: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 070: fd ff ff ff fd ff ff ff 18 00 00 00 1f 00 00 00
>
bufctl[0x18] 0x1b instead of 0x1f yields a valid bufctl chain.
> 080: fd ff ff ff fd ff ff ff 1c 00 00 00 ff ff ff ff
> 090: fd ff ff ff fd ff ff ff fd ff ff ff
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:2949!
> invalid opcode: 0000 [#1] SMP
> last sysfs file:
>
>
> slab: Internal list corruption detected in cache 'size-128'(26), slabp f2905000(20). Hexdump:
>
> 000: 00 e0 12 f2 88 32 c0 f7 88 00 00 00 88 50 90 f2
> 010: 14 00 00 00 0f 00 00 00 00 00 00 00 ff ff ff ff
> 020: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 030: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 040: fd ff ff ff fd ff ff ff 00 00 00 00 fd ff ff ff
> 050: fd ff ff ff fd ff ff ff 19 00 00 00 17 00 00 00
>
bufctl[0x10]: 0x13 instead of 0x17 creates a valid tree
> 060: fd ff ff ff fd ff ff ff 0b 00 00 00 fd ff ff ff
> 070: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 080: 10 00 00 00
>
>

> slab: Internal list corruption detected in cache 'size-128'(26), slabp f7159000(18). Hexdump:
>
> 000: 00 f0 f8 f2 88 32 c0 f7 88 00 00 00 88 90 15 f7
> 010: 12 00 00 00 08 00 00 00 00 00 00 00
bufctl[0x00] 13 00 00 00 020: fd ff ff ff fd ff ff ff fd ff ff ff
bufctl[0x04]  fd ff ff ff 030: 06 00 00 00 ff ff ff ff fd ff ff ff
bufctl[0x08] 18 00 00 00 040: fd ff ff ff fd ff ff ff 17 00 00 00
bufctl[0x0c] fd ff ff ff 050: fd ff ff ff fd ff ff ff fd ff ff ff
bufctl[0x10] fd ff ff ff 060: fd ff ff ff fd ff ff ff 05 00 00 00
bufctl[0x14] fd ff ff ff 070: fd ff ff ff fd ff ff ff 00 00 00 00
bufctl[0x18] 0f 00 00 00 080: fd ff ff ff

bufctl[0x18] is wrong, it must be 0x0b

> slab: Internal list corruption detected in cache 'size-128'(26), slabp ed9a9000(21). Hexdump:
>
> 000: 00 c0 3a f3 88 32 80 f7 88 00 00 00 88 90 9a ed
> 010: 15 00 00 00 12 00 00 00 00 00 00 00
bufcfl[0x00] fd ff ff ff 020: fd ff ff ff fd ff ff ff 07 00 00 00
bufctl[0x04] fd ff ff ff 030: fd ff ff ff fd ff ff ff 08 00 00 00
bufctl[0x08] 0f 00 00 00 040: fd ff ff ff fd ff ff ff ff ff ff ff
bufctl[0x0c] fd ff ff ff 050: fd ff ff ff fd ff ff ff fd ff ff ff
bufctl[0x10] fd ff ff ff 060: fd ff ff ff 03 00 00 00 fd ff ff ff
bufctl[0x14] fd ff ff ff 070: fd ff ff ff fd ff ff ff fd ff ff ff
bufctl[0x18 fd ff ff ff 080: fd ff ff ff

bufctl[0x08] is wrong, it must be 0x0b instead of 0x0f

> but they're all from under basically the same conditions.
>
All bugs appear to be a spurious 0x04 in a bufctl[nr%8==0].

Either someone does a set_bit() or your cpu is breaking down.

 From looking at the the msgctl08 test: it shouldn't produce any races,
it just does lots of bulk msgsnd()/msgrcv() operations. Always one
thread sends, one thread receives on each queue. It's probably more a
scheduler stresstest than anything else.

Attached is a completely untested patch:
- add 8 bytes to each slabp struct: This changes the alignment of the
bufctl entries.
- add a hexdump of the redzone bytes. Andrew: how do you log the oops?
it might scroll of the screen.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~repeatable-slab-corruption-with-ltp-msgctl08 mm/slab.c
--- a/mm/slab.c~repeatable-slab-corruption-with-ltp-msgctl08
+++ a/mm/slab.c
@@ -219,6 +219,7 @@ typedef unsigned int kmem_bufctl_t;
  */
 struct slab {
 	struct list_head list;
+	unsigned long buh;
 	unsigned long colouroff;
 	void *s_mem;		/* including colour offset */
 	unsigned int inuse;	/* num of objs active in slab */
@@ -2943,7 +2944,18 @@ bad:
 		     i++) {
 			if (i % 16 == 0)
 				printk("\n%03x:", i);
-			printk(" %02x", ((unsigned char *)slabp)[i]);
+			printk(" %0x", ((unsigned char *)slabp)[i]);
+		}
+		printk("\n");
+		if (!OFF_SLAB(cachep) && (cachep->flags & SLAB_RED_ZONE)) {
+			printk("redzone codes:\n");
+			for (i = 0; i < cachep->num; i++) {
+				void *objp = index_to_obj(cachep, slabp, i);
+
+				if (i % 2 == 0)
+					printk("\n%03x:", i);
+				printk("%llx/%llx ", *dbg_redzone1(cachep, objp), *dbg_redzone2(cachep, objp));
+			}
 		}
 		printk("\n");
 		BUG();
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes.patch
forcedeth-msi-interrupts.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
ipc-use-simple_read_from_buffer.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

